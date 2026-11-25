const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

const services = [
  { name: 'Plumbing Overhaul', category: 'plumbing', description: 'Pipe leaks, taps, and sanitary repair', base_price: 349, price_unit: 'visit', icon: 'wrench', is_complex: 0, is_active: 1 },
  { name: 'Appliance AC Servicing', category: 'appliances', description: 'Chemical wash, filter clean and gas check', base_price: 699, price_unit: 'unit', icon: 'air-vent', is_complex: 0, is_active: 1 },
  { name: 'Carpentry & Furniture Repair', category: 'carpentry', description: 'Door locks, hinges, and woodwork', base_price: 399, price_unit: 'visit', icon: 'hammer', is_complex: 0, is_active: 1 },
  { name: 'Home Deep Cleaning', category: 'cleaning', description: 'Full bathroom, kitchen and room cleaning', base_price: 899, price_unit: 'service', icon: 'sparkles', is_complex: 0, is_active: 1 },
  { name: 'Masonry & Tile Patching', category: 'masonry', description: 'Grout sealing and plaster repair', base_price: 549, price_unit: 'visit', icon: 'brick-wall', is_complex: 0, is_active: 1 },
  { name: 'CCTV & Security Setup', category: 'it_cctv', description: 'IP security cameras and Wi-Fi install', base_price: 799, price_unit: 'device', icon: 'camera', is_complex: 0, is_active: 1 },
  { name: 'Gardening & Landscaping', category: 'gardening', description: 'Lawn mowing and plant maintenance', base_price: 399, price_unit: 'hour', icon: 'flower2', is_complex: 0, is_active: 1 }
];

async function seedServices() {
  await client.connect();
  for (const s of services) {
    await client.query(
      'INSERT INTO services (name, category, description, base_price, price_unit, icon, is_complex, is_active) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)',
      [s.name, s.category, s.description, s.base_price, s.price_unit, s.icon, s.is_complex, s.is_active]
    );
  }
  const res = await client.query('SELECT count(*) FROM services');
  console.log('✅ Services count in Supabase:', res.rows[0].count);
  await client.end();
}

seedServices().catch(err => {
  console.error(err);
  process.exit(1);
});
