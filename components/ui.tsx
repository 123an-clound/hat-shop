'use client';
import Image from 'next/image';
import { useEffect, useRef, useState } from 'react';
import { X } from 'lucide-react';
export function Photo({src,alt,className='',priority=false,sizes='(max-width: 640px) 50vw, 25vw'}:{src:string;alt:string;className?:string;priority?:boolean;sizes?:string}) {
 const [failed,setFailed]=useState(false);
 useEffect(()=>setFailed(false),[src]);
 const remote=src.startsWith('https://')&&!src.includes('images.unsplash.com')&&!src.includes('.supabase.co');
 return <Image src={failed?'/images/cap-beige.webp':src||'/images/cap-beige.webp'} alt={alt} fill sizes={sizes} priority={priority} fetchPriority={priority?'high':undefined} unoptimized={remote} className={className} onError={()=>setFailed(true)}/>;
}
export function Modal({title,children,onClose,drawer=false}:{title:string;children:React.ReactNode;onClose:()=>void;drawer?:boolean}) {
 const ref=useRef<HTMLDialogElement>(null);
 useEffect(()=>{const el=ref.current;el?.showModal();const old=document.body.style.overflow;document.body.style.overflow='hidden';return()=>{el?.close();document.body.style.overflow=old;};},[]);
 return <dialog ref={ref} className={drawer?'dialog drawer':'dialog'} aria-label={title} onCancel={onClose} onClick={e=>{if(e.target===ref.current)onClose();}}><div className="dialog-inner"><div className="dialog-heading"><h2>{title}</h2><button className="icon-button" aria-label="Đóng" onClick={onClose}><X size={22}/></button></div>{children}</div></dialog>;
}
export function Empty({title,description,children}:{title:string;description?:string;children?:React.ReactNode}) { return <div className="empty"><h2>{title}</h2>{description&&<p>{description}</p>}{children}</div>; }
export function Message({text,error=false}:{text:string;error?:boolean}) {return text?<p className={error?'message error':'message'} role={error?'alert':'status'}>{text}</p>:null;}
