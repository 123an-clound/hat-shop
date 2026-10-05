'use client';
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { CartItem } from '@/types';
interface Store { items:CartItem[]; wishlist:string[]; add:(item:CartItem)=>void; quantity:(id:string,q:number)=>void; remove:(id:string)=>void; clear:()=>void; toggleWish:(id:string)=>void }
export const useCart = create<Store>()(persist((set)=>({items:[],wishlist:[],
 add:(item)=>set(s=>{const old=s.items.find(i=>i.variantId===item.variantId);return {items:old?s.items.map(i=>i.variantId===item.variantId?{...item,quantity:Math.min(i.quantity+item.quantity,item.maxStock)}:i):[...s.items,{...item,quantity:Math.min(item.quantity,item.maxStock)}]};}),
 quantity:(id,q)=>set(s=>({items:s.items.map(i=>i.variantId===id?{...i,quantity:Math.max(1,Math.min(Math.floor(q)||1,i.maxStock))}:i)})),
 remove:(id)=>set(s=>({items:s.items.filter(i=>i.variantId!==id)})),clear:()=>set({items:[]}),
 toggleWish:(id)=>set(s=>({wishlist:s.wishlist.includes(id)?s.wishlist.filter(x=>x!==id):[...s.wishlist,id]})),
}),{name:'urban-caps-cart-v1'}));
