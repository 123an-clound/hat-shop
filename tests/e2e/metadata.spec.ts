import { test,expect } from '@playwright/test';

test('public pages expose metadata and product structured data',async({page,request})=>{
 for(const route of ['/','/shop','/shop/snapback','/product/essential-6-panel-cap','/lookbook','/size-guide','/policies']){
  const response=await page.goto(route);
  expect(response?.status()).toBe(200);
  await expect(page.locator('main h1')).toHaveCount(1);
  await expect(page.locator('head meta[name="description"]')).toHaveAttribute('content',/.{30}/);
  await expect(page.locator('head link[rel="canonical"]')).toHaveAttribute('href',/^https?:\/\//);
 }
 await page.goto('/product/essential-6-panel-cap');
 const data=JSON.parse(await page.locator('script[type="application/ld+json"]').innerText());
 expect(data['@type']).toBe('Product');
 expect(data.offers.priceCurrency).toBe('VND');
 const robots=await request.get('/robots.txt');expect(robots.status()).toBe(200);
 const sitemap=await request.get('/sitemap.xml');expect(sitemap.status()).toBe(200);
});
