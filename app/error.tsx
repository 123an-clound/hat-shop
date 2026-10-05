'use client';
export default function ErrorPage({reset}:{reset:()=>void}){return <main id="main-content" className="container empty"><h1>Chưa tải được nội dung.</h1><p>Vui lòng kiểm tra kết nối rồi thử lại.</p><button className="button" onClick={reset}>Thử lại</button></main>;}
