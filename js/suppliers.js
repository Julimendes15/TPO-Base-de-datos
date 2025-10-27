document.body.dataset = {page:'suppliers'};

async function loadSuppliers(){
  let list = await API.get('/api/suppliers');
  if(!list){
    list = [
      {company:'Maderas Patagónicas SRL', email:'ventas@patagonicas.com', phone:'+54 11 5555-1111', materials:['roble','ciprés']},
      {company:'Herrajes Río', email:'contacto@herrajesrio.com', phone:'+54 11 5555-2222', materials:['bisagras','correderas']}
    ];
  }
  const tbody = document.querySelector('#suppliers-table tbody');
  tbody.innerHTML = '';
  list.forEach(s=>{
    const tr = document.createElement('tr');
    tr.innerHTML = `<td>${s.company}</td><td>${s.email}</td><td>${s.phone}</td><td>${Array.isArray(s.materials)?s.materials.join(', '):s.materials}</td>`;
    tbody.appendChild(tr);
  });
}

document.getElementById('signup-form')?.addEventListener('submit', async (e)=>{
  e.preventDefault();
  const payload = Object.fromEntries(new FormData(e.target).entries());
  payload.materials = payload.materials?.split(',').map(x=>x.trim()).filter(Boolean);
  try{
    await API.post('/api/suppliers', payload);
    alert('Proveedor registrado.');
    e.target.reset();
    loadSuppliers();
  }catch(err){
    console.warn('Fallo POST /api/suppliers. Simulando...', err);
    alert('Proveedor registrado (simulado).');
    loadSuppliers();
  }
});

document.getElementById('login-form')?.addEventListener('submit', async (e)=>{
  e.preventDefault();
  const payload = Object.fromEntries(new FormData(e.target).entries());
  try{
    await API.post('/api/suppliers/login', payload);
    alert('Ingreso correcto.');
  }catch(err){
    console.warn('Fallo login suppliers. Simulando...', err);
    alert('Ingreso correcto (simulado).');
  }
});

loadSuppliers();
