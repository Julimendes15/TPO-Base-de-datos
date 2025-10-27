// Centraliza endpoints para conectar con tu backend SQL vía API
const API = {
  baseURL: '', // e.g. 'https://tu-dominio.com' o '' si mismo host
  async get(path){
    const url = `${this.baseURL}${path}`;
    try{
      const res = await fetch(url);
      if(!res.ok) throw new Error('HTTP '+res.status);
      return await res.json();
    }catch(e){
      console.warn('Fallo GET '+path+', usando datos de ejemplo.', e);
      return null;
    }
  },
  async post(path, payload){
    const url = `${this.baseURL}${path}`;
    const res = await fetch(url, {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(payload)});
    if(!res.ok) throw new Error('HTTP '+res.status);
    return await res.json();
  }
};
