import Header from '@/components/storefront/Header';
import Footer from '@/components/storefront/Footer';
import { getCatalog } from '@/lib/catalog';
export default async function StoreLayout({children}:{children:React.ReactNode}) {const {settings}=await getCatalog();return <><Header announcement={settings.announcement_bar_text}/><main id="main-content">{children}</main><Footer settings={settings}/></>;}
