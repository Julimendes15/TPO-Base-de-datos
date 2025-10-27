document.body.dataset = {page:'catalog'};

function getCart(){ try{return JSON.parse(localStorage.getItem('cart')||'[]');}catch{ return [];} }
function setCart(items){ localStorage.setItem('cart', JSON.stringify(items)); updateCount(); }
function updateCount(){
  const countEl = document.getElementById('cart-count');
  if(countEl){ countEl.textContent = getCart().reduce((a,i)=>a+i.qty,0); }
}

async function loadProducts(){
  const search = document.getElementById('search').value.trim().toLowerCase();
  const cat = document.getElementById('category').value;
  let data = await API.get('/api/products');
  if(!data){
    // Fallback data if API not available
    data = [
      {id:1, name:'Mesa de roble', category:'Mesas', price:249.99, image:'https://images.unsplash.com/photo-1505692794403-34d4982f88aa?q=80&w=1200&auto=format&fit=crop'},
      {id:2, name:'Silla nórdica', category:'Sillas', price:79.99, image:'https://images.unsplash.com/photo-1549497538-303791108f95?q=80&w=1200&auto=format&fit=crop'},
      {id:3, name:'Aparador minimal', category:'Almacenamiento', price:399.00, image:'https://images.unsplash.com/photo-1556909212-d5b604d0c90b?q=80&w=1200&auto=format&fit=crop'},
      {id:4, name:'Mesa ratona', category:'Mesas', price:129.00, image:'https://images.unsplash.com/photo-1455875836392-bb4958f19bc2?q=80&w=1200&auto=format&fit=crop'},
      {id:5, name:'Silla plegable', category:'Sillas', price:49.00, image:'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=1200&auto=format&fit=crop'},
      {id:6, name:'Biblioteca modular', category:'Almacenamiento', price:549.00, image:'https://images.unsplash.com/photo-1493666438817-866a91353ca9?q=80&w=1200&auto=format&fit=crop'}
    ];
  }
  if(cat) data = data.filter(p=>p.category===cat);
  if(search) data = data.filter(p=>p.name.toLowerCase().includes(search));
  renderProducts(data);
}

function renderProducts(list){
  const grid = document.getElementById('product-grid');
  grid.innerHTML = '';
  list.forEach(p=>{
    const card = document.createElement('article');
    card.className = 'card product';
    card.innerHTML = `
      <img src="${p.image}" alt="${p.name}">
      <h3>${p.name}</h3>
      <div class="meta">
        <span class="badge">${p.category}</span>
        <span class="price">$${p.price.toFixed(2)}</span>
      </div>
      <button class="btn primary" data-add="${p.id}">Agregar al carrito</button>
    `;
    grid.appendChild(card);
  });
  grid.querySelectorAll('[data-add]').forEach(btn=>{
    btn.addEventListener('click', ()=> addToCart(parseInt(btn.dataset.add)));
  });
}

function addToCart(id){
  // Ideally validate with backend: /api/products/:id
  const items = getCart();
  const existing = items.find(i=>i.id===id);
  if(existing){ existing.qty += 1; }
  else { items.push({id, qty:1}); }
  setCart(items);
  alert('Producto agregado.');
}

document.getElementById('search').addEventListener('input', loadProducts);
document.getElementById('category').addEventListener('change', loadProducts);
loadProducts();
updateCount();
