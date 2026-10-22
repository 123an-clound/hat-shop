'use client';
import { useEffect, useState } from 'react';
import { Moon, Sun } from 'lucide-react';
export default function ThemeToggle(){const [light,setLight]=useState(false);useEffect(()=>setLight(document.documentElement.dataset.theme==='light'),[]);const toggle=()=>{const next=!light;setLight(next);document.documentElement.dataset.theme=next?'light':'dark';try{localStorage.setItem('theme',next?'light':'dark');}catch{/* storage blocked: theme still applies for this visit */}};return <button type="button" className="icon-button" onClick={toggle} aria-label={light?'Chuyển sang giao diện tối':'Chuyển sang giao diện sáng'} title={light?'Giao diện tối':'Giao diện sáng'}>{light?<Moon size={19}/>:<Sun size={19}/>}</button>;}
