document.body.dataset = {page: (location.pathname.endsWith('cart.html') ? 'catalog' : document.body.dataset?.page)};

function getCart(){ try{return JSON.parse(localStorage.getItem('cart')||'[]');}catch{ return [];} }
function setCart(items){ localStorage.setItem('cart', JSON.stringify(items)); const c=document.getElementById('cart-count'); if(c) c.textContent = items.reduce((a,i)=>a+i.qty,0); }

async function fetchProduct(id){
  // Try backend first
  const res = await API?.get?.(`/api/products/${id}`);
  if(res) return res;
  // Fallback: name and price based on mock (keep in sync with catalog.js)
  const mock = {
    1:{id:1, name:'Mesa de roble', price:249.99, image:'https://images.unsplash.com/photo-1505692794403-34d4982f88aa?q=80&w=1200&auto=format&fit=crop'},
    2:{id:2, name:'Silla nórdica', price:79.99, image:'https://images.unsplash.com/photo-1549497538-303791108f95?q=80&w=1200&auto=format&fit=crop'},
    3:{id:3, name:'Aparador minimal', price:399.00, image:'https://images.unsplash.com/photo-1556909212-d5b604d0c90b?q=80&w=1200&auto=format&fit=crop'},
    4:{id:4, name:'Mesa ratona', price:129.00, image:'https://images.unsplash.com/photo-1455875836392-bb4958f19bc2?q=80&w=1200&auto=format&fit=crop'},
    5:{id:5, name:'Silla plegable', price:49.00, image:'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=1200&auto=format&fit=crop'},
    6:{id:6, name:'Biblioteca modular', price:549.00, image:'https://images.unsplash.com/photo-1493666438817-866a91353ca9?q=80&w=1200&auto=format&fit=crop'}
  };
  return mock[id];
}

async function renderCart(){
  const items = getCart();
  const container = document.getElementById('cart-items');
  if(!container) return;
  container.innerHTML = '';
  let total = 0;
  for(const it of items){
    const p = await fetchProduct(it.id);
    const lineTotal = p.price * it.qty;
    total += lineTotal;
    const row = document.createElement('div');
    row.className = 'cart-item';
    row.innerHTML = `
      <img src="${p.image}" alt="${p.name}"/>
      <div>
        <strong>${p.name}</strong>
        <div class="muted small">$${p.price.toFixed(2)} c/u</div>
      </div>
      <div>
        <input type="number" min="1" value="${it.qty}" style="width:70px" data-qty="${it.id}"/>
      </div>
      <div><strong>$${lineTotal.toFixed(2)}</strong> <button class="btn" data-del="${it.id}">✕</button></div>
    `;
    container.appendChild(row);
  }
  const totalEl = document.getElementById('cart-total');
  if(totalEl) totalEl.textContent = `Total: $${total.toFixed(2)}`;

  container.querySelectorAll('[data-qty]').forEach(inp=>{
    inp.addEventListener('change', (e)=>{
      const id = parseInt(inp.dataset.qty); const qty = Math.max(1, parseInt(e.target.value||'1'));
      const items = getCart(); const it = items.find(x=>x.id===id); if(it){ it.qty = qty; setCart(items); renderCart(); }
    });
  });
  container.querySelectorAll('[data-del]').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      const id = parseInt(btn.dataset.del);
      const items = getCart().filter(x=>x.id!==id); setCart(items); renderCart();
    });
  });

  document.getElementById('checkout-btn')?.addEventListener('click', async ()=>{
    const items = getCart();
    if(items.length===0) return alert('El carrito está vacío.');
    try{
      const res = await fetch('/api/orders', {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({items})});
      if(!res.ok) throw new Error('HTTP '+res.status);
      alert('Pedido enviado. ¡Gracias!');
      setCart([]); renderCart();
    }catch(err){
      console.warn('Fallo POST /api/orders. Simulando éxito.', err);
      alert('Pedido enviado (simulado). ¡Gracias!');
      setCart([]); renderCart();
    }
  });
}

renderCart();
