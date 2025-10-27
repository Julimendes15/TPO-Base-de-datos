(function(){
  const active = document.querySelector(`a[data-nav="${document.body.dataset?.page}"]`);
  if(active) active.classList.add("active");
  document.getElementById("year")?.appendChild(document.createTextNode(new Date().getFullYear()));

  // Simple contact form mock
  const contact = document.getElementById("contact-form");
  if(contact){
    contact.addEventListener("submit", async (e)=>{
      e.preventDefault();
      const payload = Object.fromEntries(new FormData(contact).entries());
      // Replace with your backend endpoint:
      try{
        const res = await fetch('/api/contact', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(payload)});
        if(!res.ok) throw new Error('HTTP '+res.status);
        alert('Gracias, te responderemos pronto.');
        contact.reset();
      }catch(err){
        console.warn('Fallo POST /api/contact. Simulando éxito.', err);
        alert('Gracias, te responderemos pronto. (Simulado)');
      }
    });
  }

  // Update cart count from localStorage
  function getCart(){ try{return JSON.parse(localStorage.getItem('cart')||'[]');}catch{ return [];} }
  const countEl = document.getElementById('cart-count');
  if(countEl){ countEl.textContent = getCart().reduce((a,i)=>a+i.qty,0); }
})();
