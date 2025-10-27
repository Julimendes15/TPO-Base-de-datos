document.body.dataset = {page:'analytics'};

async function loadCharts(){
  let sales = await API?.get?.('/api/sales');
  let top = await API?.get?.('/api/top-products');
  let byCat = await API?.get?.('/api/revenue');

  if(!sales) sales = {labels:['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'], values:[12,19,13,25,22,30,28,26,32,21,18,24]};
  if(!top) top = {labels:['Mesa roble','Silla nórdica','Aparador','Mesa ratona','Biblioteca'], values:[320,280,190,170,120]};
  if(!byCat) byCat = {labels:['Mesas','Sillas','Almacenamiento'], values:[12000,7500,9800]};

  new Chart(document.getElementById('salesByMonth'), {
    type:'line',
    data:{ labels:sales.labels, datasets:[{ label:'Ventas', data:sales.values, tension:.3, fill:false }]},
    options:{ responsive:true, plugins:{ legend:{display:false} } }
  });

  new Chart(document.getElementById('topProducts'), {
    type:'bar',
    data:{ labels:top.labels, datasets:[{ label:'Unidades', data:top.values }]},
    options:{ responsive:true, plugins:{ legend:{display:false} } }
  });

  new Chart(document.getElementById('revenueByCategory'), {
    type:'doughnut',
    data:{ labels:byCat.labels, datasets:[{ data:byCat.values }]},
    options:{ responsive:true }
  });
}
loadCharts();
