const { Client } = require('pg');
require('dotenv').config();

const c = new Client({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

const seedServices = [
  ['Split AC Deep Jet Cleaning & Service', 'Appliance Repair', 'High-pressure water jacket coil wash, indoor blower sanitization, filter cleaning & cooling audit', 449, 'per_unit', 60, 'Wrench'],
  ['Split AC Installation (New/Relocation)', 'Appliance Repair', 'Outdoor wall-bracket anchor mounting, flare copper piping hookup, nitrogen vacuuming & testing', 899, 'per_unit', 90, 'Wrench'],
  ['AC Gas Leak Repair & Refilling', 'Appliance Repair', 'Nitrogen pressure leak detection, copper brazing, system evacuation & R32/R410A gas charge', 1499, 'per_unit', 75, 'Wrench'],
  ['Inverter AC PCB Diagnostics & Repair', 'Appliance Repair', 'Microcontroller IPM module testing, sensor calibration, capacitor replacement & relay test', 849, 'per_unit', 90, 'Wrench'],
  ['Double-Door Refrigerator Cooling & Gas Charge', 'Appliance Repair', 'Inverter compressor diagnostic, capillary tube flush, thermostat repair & R600a hydrocarbon charge', 699, 'per_unit', 60, 'Wrench'],
  ['Fully-Automatic Washing Machine Repair', 'Appliance Repair', 'Drum spider bracket replacement, drain pump unclogging, motor belt tensioning & noise fix', 399, 'per_unit', 45, 'Wrench'],
  ['Kitchen Chimney & Hob Deep Degreasing', 'Appliance Repair', 'Caustic-free chemical baffle filter dip, exhaust motor impeller degreasing & duct checking', 499, 'per_unit', 60, 'Wrench'],
  ['Microwave Oven Magnetron & Touchpad Service', 'Appliance Repair', 'Magnetron emission testing, high-voltage diode replacement & membrane touch switch repair', 349, 'per_visit', 45, 'Wrench'],
  ['Switch, Socket & Modular Plate Replacement', 'Electrical', 'Fire-resistant ISI certified modular switch/socket replacement with load verification', 129, 'per_point', 30, 'Zap'],
  ['Ceiling Fan Installation & Overhaul', 'Electrical', 'Downrod ceiling anchor fitting, heavy capacitor upgrade & noise-free dynamic blade balancing', 179, 'per_fan', 40, 'Wind'],
  ['Main MCB & Distribution Board Replacement', 'Electrical', 'Short circuit protection, 32A/63A DP isolator & modular miniature circuit breaker wiring', 499, 'per_board', 75, 'Zap'],
  ['Inverter & Battery Home Wiring Setup', 'Electrical', 'Tubular battery acid terminal conditioning, heavy copper wiring & bypass switch integration', 599, 'per_setup', 90, 'Zap'],
  ['Complete House Concealed Rewiring', 'Electrical', 'Wall chasing, PVC conduit routing, FR multi-strand copper wire pulling & earth resistance test', 1999, 'per_sqft', 480, 'Zap'],
  ['Chandelier & Designer Pendant Light Fitting', 'Electrical', 'Ceiling rawl plug anchor drilling, counterweight balancing & multi-tier chandelier assembly', 399, 'per_light', 60, 'Zap'],
  ['EV Four-Wheeler Home Charger Line (7.4kW)', 'Electrical', 'Dedicated 40A MCB, 10 sq.mm heavy cable run & dedicated copper chemical earth electrode pit', 1799, 'per_setup', 180, 'Zap'],
  ['Electric Geyser Fast Heating Diagnostic & Repair', 'Electrical', 'Incoloy heating element replacement, dual thermostat calibration & earth leakage testing', 299, 'per_visit', 45, 'Zap'],
  ['Emergency Electrical Short Circuit Diagnostics', 'Electrical', 'Megger insulation testing, burnt wire replacement & emergency circuit isolation', 399, 'per_visit', 45, 'Zap'],
  ['Tap, Spout & Flush Valve Leak Repair', 'Plumbing', 'Brass spindle cartridge replacement, ceramic disc renewal & teflon high-pressure thread seal', 129, 'per_tap', 30, 'Droplets'],
  ['Western Commode EWC & Cistern Installation', 'Plumbing', 'Floor waste pipe wax ring seal, soft-close hydraulic seat cover & dual-flush tank assembly', 649, 'per_unit', 90, 'Droplets'],
  ['Overhead Water Tank High-Pressure Disinfection', 'Plumbing', 'Automated sludge evacuation, rotary nylon jet scrubbing & non-toxic UV/chlorine sanitization', 549, 'per_tank', 60, 'Droplets'],
  ['Automatic Water Booster Pump Installation', 'Plumbing', '0.5HP-1.0HP self-priming pressure pump hookup with flow sensor & anti-vibration rubber pads', 699, 'per_unit', 90, 'Droplets'],
  ['Bathroom Multi-Flow Concealed Diverter Overhaul', 'Plumbing', 'Jaquar/Grohe cartridge replacement, brass sleeve greasing & mixer diverter recalibration', 399, 'per_unit', 60, 'Droplets'],
  ['Blocked Drain & Sewer Pipe De-clogging', 'Plumbing', 'Heavy mechanical steel snake auger insertion & high-flow pressurized drain jetting', 349, 'per_drain', 45, 'Droplets'],
  ['Water Purifier RO + UV Complete Filter Replacement', 'Plumbing', 'Sediment filter, pre-carbon block, 75 GPD membrane replacement & TDS balancing test', 599, 'per_service', 60, 'Droplets'],
  ['Emergency 60-Min Main Pipe Burst Containment', 'Plumbing', 'Rapid on-site emergency water cutoff, compression coupling & CPVC line repair', 499, 'per_visit', 45, 'Droplets'],
  ['Flatpack Furniture Assembly (Bed, Wardrobe, Desk)', 'Carpentry', 'IKEA/Pepperfry flatpack cam-lock joinery, drawer slide alignment & leveling', 499, 'per_item', 90, 'Hammer'],
  ['High-Security Main Door Mortise Lock Fitting', 'Carpentry', 'Godrej/Yale 6-lever mortise lock cavity mortising, cylinder keying & striker alignment', 349, 'per_lock', 60, 'Hammer'],
  ['Modular Kitchen Soft-Close Hydraulic Hinge Upgrade', 'Carpentry', 'Clip-on hydraulic soft-close hinge fitting, shutter plumb alignment & magnetic catches', 249, 'per_cabinet', 45, 'Hammer'],
  ['Wooden Door Planing, Trimming & Floor Clearance', 'Carpentry', 'Power planer edge leveling, jamb recess shimming & brass butt hinge lubrication', 229, 'per_door', 45, 'Hammer'],
  ['Aluminium Sliding Window Roller & Track Overhaul', 'Carpentry', 'Bearing wheel renewal, aluminium anodized track cleaning & nylon brush weatherstripping', 279, 'per_window', 45, 'Hammer'],
  ['Premium French Spirit & Wood PU Clear Polish', 'Carpentry', 'Shellac hand pad buffing, grain filler staining & dual-coat polyurethane protective coat', 35, 'per_sqft', 120, 'Hammer'],
  ['Interior Luxury Silk Emulsion Painting', 'Painting', 'Acrylic wall putty base leveling, primer seal & dual-coat Asian Paints Royale silk finish', 11, 'per_sqft', 240, 'Paintbrush'],
  ['Terrace Chemical Elastomeric Waterproofing', 'Painting', 'Fiberglass mesh reinforcement, crack sealing & 3-layer UV reflective polymer membrane coat', 28, 'per_sqft', 360, 'Paintbrush'],
  ['Exterior Anti-Fungal Weathercoat Painting', 'Painting', 'High-pressure water blaster moss removal, biocide wash & dirt-pick-resistant exterior coat', 14, 'per_sqft', 300, 'Paintbrush'],
  ['Wall Putty Application & Machine Sanding', 'Painting', 'Two coats of waterproof white cement putty followed by 180-grit vacuum sander smoothing', 7, 'per_sqft', 180, 'Paintbrush'],
  ['Seepage Damp Treatment with Injection Grouting', 'Painting', 'PU chemical foam wall crack injection & moisture barrier hydrophobic plaster treatment', 48, 'per_sqft', 240, 'Paintbrush'],
  ['Full Apartment Deep Machine Cleaning', 'Cleaning', 'Single-disc rotary floor buffing, vacuuming, window track cleaning & chemical sanitization', 1499, 'per_apartment', 240, 'SprayCan'],
  ['Intensive Kitchen Oil & Grease Descaling', 'Cleaning', 'Industrial food-grade chemical degreaser on ceramic tiles, cooktop, slab & exhaust vent', 699, 'per_kitchen', 120, 'SprayCan'],
  ['Bathroom Acid Free Descaling & Grout Restoration', 'Cleaning', 'Limescale dissolution from glass partitions, chrome taps & high-pressure tile steam scrubbing', 399, 'per_bathroom', 60, 'SprayCan'],
  ['Sofa & Mattress Foam Shampoo & Extraction Wash', 'Cleaning', 'German injection-extraction deep foam wash for dust-mite elimination & stain removal', 499, 'per_sofa_set', 75, 'SprayCan'],
  ['Odorless Herbal Gel Cockroach & Pest Barrier', 'Cleaning', 'Fipronil herbal bait dots across kitchen cabinets, drain perimeters & 90-day protection warranty', 599, 'per_home', 60, 'SprayCan'],
  ['Lawn Mowing & Landscape Shrub Pruning', 'Gardening', 'Motorized lawn mower trimming, boundary hedge shaping, aerating & vermicompost feeding', 349, 'per_garden', 90, 'Flower2'],
  ['Terrace Garden Micro Drip Automation Setup', 'Gardening', 'Automated timer valve hookup, 16mm LDPE main line & individual potted plant micro drippers', 999, 'per_terrace', 120, 'Flower2'],
  ['Elderly Bedside Attendant (Daily Day Care)', 'Caregiving', 'Patient mobility assistance, vitals monitoring (BP, SpO2, Sugar), hygiene & medicine compliance', 699, 'per_day', 480, 'HeartPulse'],
  ['Post-Operative Dressing & Injection Nursing Visit', 'Caregiving', 'Sterile wound surgical dressing, IV line check, vitals documentation & nursing report', 249, 'per_visit', 45, 'HeartPulse'],
  ['Professional City Chauffeur (8-Hour Shift)', 'Driving', 'Background-verified licensed chauffeur for manual and automatic luxury / hatchback cars', 599, 'per_day', 480, 'Car'],
  ['Outstation Long-Distance Highway Chauffeur', 'Driving', 'Expert highway driver with all-India permit credentials & night-driving endurance', 899, 'per_day', 600, 'Car']
];

async function sync() {
  await c.connect();
  await c.query('TRUNCATE TABLE services RESTART IDENTITY CASCADE;');
  for (const s of seedServices) {
    const isComplex = s[5] > 90 ? 1 : 0;
    await c.query(
      'INSERT INTO services (name, category, description, base_price, price_unit, icon, is_complex, is_active) VALUES ($1, $2, $3, $4, $5, $6, $7, 1)',
      [s[0], s[1], s[2], s[3], s[4], s[6], isComplex]
    );
  }
  const count = await c.query('SELECT count(*) FROM services');
  console.log('✅ ALL 47 SERVICES INSERTED! Total in Supabase:', count.rows[0].count);
  await c.end();
}

sync().catch(err => {
  console.error(err);
  process.exit(1);
});
