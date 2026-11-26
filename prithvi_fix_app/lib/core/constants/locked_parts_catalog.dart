class LockedPartItem {
  final String name;
  final String mrp;
  final String coopPrice;
  final String warranty;

  const LockedPartItem({
    required this.name,
    required this.mrp,
    required this.coopPrice,
    required this.warranty,
  });
}

class ServiceLockedPartsCatalog {
  static final Map<String, List<LockedPartItem>> _categoryParts = {
    // ----------------------------------------------------
    // PLUMBING & WATER SYSTEMS
    // ----------------------------------------------------
    'plumbing': [
      const LockedPartItem(name: 'Ceramic Disc Cartridge (Mixer Tap)', mrp: '₹380', coopPrice: '₹220', warranty: '12 Months'),
      const LockedPartItem(name: 'PVC Flexible Hose 3/4 inch (per metre)', mrp: '₹75', coopPrice: '₹38', warranty: '6 Months'),
      const LockedPartItem(name: 'Toilet Flush Valve (Universal EWC)', mrp: '₹550', coopPrice: '₹350', warranty: '12 Months'),
      const LockedPartItem(name: 'CPVC Ball Valve 1/2 inch (ISI)', mrp: '₹210', coopPrice: '₹120', warranty: '24 Months'),
      const LockedPartItem(name: 'Tap Washer & O-Ring Set (10 pcs)', mrp: '₹80', coopPrice: '₹35', warranty: '3 Months'),
      const LockedPartItem(name: 'Teflon Sealing Tape (19mm x 12m)', mrp: '₹45', coopPrice: '₹25', warranty: '3 Months'),
    ],

    // ----------------------------------------------------
    // ELECTRICAL SERVICES
    // ----------------------------------------------------
    'electrical': [
      const LockedPartItem(name: 'MCB 16A/32A Single Pole (Havells/Legrand)', mrp: '₹380', coopPrice: '₹220', warranty: '24 Months'),
      const LockedPartItem(name: 'Ceiling Fan Heavy Capacitor 2.5µF', mrp: '₹220', coopPrice: '₹120', warranty: '6 Months'),
      const LockedPartItem(name: 'Modular Switch 6A (Anchor / Roma)', mrp: '₹150', coopPrice: '₹85', warranty: '12 Months'),
      const LockedPartItem(name: 'Electronic Fan Step Regulator', mrp: '₹320', coopPrice: '₹180', warranty: '12 Months'),
      const LockedPartItem(name: 'Copper Wire 2.5 sq.mm FR (per metre)', mrp: '₹110', coopPrice: '₹65', warranty: '6 Months'),
      const LockedPartItem(name: '3-Pin Socket 6A/16A (Fire Resistant)', mrp: '₹170', coopPrice: '₹95', warranty: '12 Months'),
    ],

    // ----------------------------------------------------
    // APPLIANCE REPAIR & MAINTENANCE
    // ----------------------------------------------------
    'appliance repair': [
      const LockedPartItem(name: 'Heavy Run Compressor Capacitor (40µF)', mrp: '₹650', coopPrice: '₹420', warranty: '12 Months'),
      const LockedPartItem(name: 'Copper Tube Thermistor Sensor (Dual)', mrp: '₹580', coopPrice: '₹280', warranty: '6 Months'),
      const LockedPartItem(name: 'Universal Refrigerator Thermostat', mrp: '₹850', coopPrice: '₹520', warranty: '12 Months'),
      const LockedPartItem(name: 'Washing Machine Heavy Belt (Universal)', mrp: '₹280', coopPrice: '₹150', warranty: '6 Months'),
      const LockedPartItem(name: 'Water Drain Motor Pump (High Lift)', mrp: '₹1250', coopPrice: '₹750', warranty: '12 Months'),
      const LockedPartItem(name: 'Geyser 2KW Copper Heating Element', mrp: '₹850', coopPrice: '₹480', warranty: '12 Months'),
    ],

    // ----------------------------------------------------
    // CARPENTRY, FURNITURE & HARDWARE
    // ----------------------------------------------------
    'carpentry': [
      const LockedPartItem(name: 'SS 304 Soft-Close Hydraulic Hinge (pair)', mrp: '₹350', coopPrice: '₹180', warranty: '24 Months'),
      const LockedPartItem(name: 'SS Mortise Lock Handle & Body Set', mrp: '₹750', coopPrice: '₹380', warranty: '24 Months'),
      const LockedPartItem(name: 'Aluminium Sliding Window Roller (Heavy Duty)', mrp: '₹220', coopPrice: '₹95', warranty: '12 Months'),
      const LockedPartItem(name: 'Telescopic Drawer Channel 18 inch (pair)', mrp: '₹320', coopPrice: '₹160', warranty: '12 Months'),
      const LockedPartItem(name: 'Magnetic Door Stopper (SS Finish)', mrp: '₹180', coopPrice: '₹95', warranty: '12 Months'),
      const LockedPartItem(name: 'Fevicol SH Wood Adhesive (1 kg)', mrp: '₹190', coopPrice: '₹120', warranty: '6 Months'),
    ],

    // ----------------------------------------------------
    // PAINTING & WATERPROOFING
    // ----------------------------------------------------
    'painting': [
      const LockedPartItem(name: 'Polymer Injection Grouting Compound (1 kg)', mrp: '₹280', coopPrice: '₹140', warranty: '12 Months'),
      const LockedPartItem(name: 'Elastomeric Waterproof Primer (per litre)', mrp: '₹210', coopPrice: '₹110', warranty: '12 Months'),
      const LockedPartItem(name: 'Acrylic Wall Putty (Birla White, 1 kg)', mrp: '₹35', coopPrice: '₹18', warranty: '6 Months'),
      const LockedPartItem(name: 'Silicon Grout Crack Filler Sealant (300ml)', mrp: '₹320', coopPrice: '₹175', warranty: '12 Months'),
      const LockedPartItem(name: 'Heavy Duty 9-inch Paint Roller Sleeve', mrp: '₹120', coopPrice: '₹65', warranty: '3 Months'),
    ],

    // ----------------------------------------------------
    // CLEANING & PEST CONTROL
    // ----------------------------------------------------
    'cleaning': [
      const LockedPartItem(name: 'Odorless Herbal Cockroach Gel (Syringe 35g)', mrp: '₹280', coopPrice: '₹145', warranty: '3 Months'),
      const LockedPartItem(name: 'Bio-Enzyme Drain Cleaner (500ml)', mrp: '₹180', coopPrice: '₹95', warranty: '6 Months'),
      const LockedPartItem(name: 'Acid-Free Grout & Tile Descaler (500ml)', mrp: '₹160', coopPrice: '₹85', warranty: '6 Months'),
      const LockedPartItem(name: 'Industrial Foam Shampoo Concentrate (1L)', mrp: '₹350', coopPrice: '₹180', warranty: '6 Months'),
    ],

    // ----------------------------------------------------
    // GARDENING & LANDSCAPING
    // ----------------------------------------------------
    'gardening': [
      const LockedPartItem(name: '16mm UV-Stabilized Drip Irrigation Pipe (10m)', mrp: '₹220', coopPrice: '₹110', warranty: '12 Months'),
      const LockedPartItem(name: 'Micro-Drip Adjustable Emitters (Pack of 20)', mrp: '₹180', coopPrice: '₹85', warranty: '12 Months'),
      const LockedPartItem(name: 'Brass Inline Water Pressure Regulator 3/4"', mrp: '₹450', coopPrice: '₹240', warranty: '12 Months'),
      const LockedPartItem(name: 'Automatic Solenoid Timer Valve', mrp: '₹1200', coopPrice: '₹680', warranty: '12 Months'),
    ],

    // ----------------------------------------------------
    // HEALTHCARE & ELDERLY CARE
    // ----------------------------------------------------
    'caregiving': [
      const LockedPartItem(name: 'Sterile Clinical Dressing & Gauze Kit', mrp: '₹180', coopPrice: '₹95', warranty: '1 Month'),
      const LockedPartItem(name: 'Medical Grade Antiseptic Solution (100ml)', mrp: '₹120', coopPrice: '₹65', warranty: '12 Months'),
      const LockedPartItem(name: 'Nitrile Patient Care Exam Gloves (Box of 50)', mrp: '₹320', coopPrice: '₹180', warranty: '6 Months'),
      const LockedPartItem(name: 'Reinforced Patient Transfer Assist Belt', mrp: '₹550', coopPrice: '₹290', warranty: '12 Months'),
    ],

    // ----------------------------------------------------
    // DRIVING & CHAUFFEUR SERVICES
    // ----------------------------------------------------
    'driving': [
      const LockedPartItem(name: 'Emergency Roadside Hazard Triangle (Reflective)', mrp: '₹280', coopPrice: '₹140', warranty: '24 Months'),
      const LockedPartItem(name: 'High-Vis Neon Chauffeur Safety Vest', mrp: '₹190', coopPrice: '₹95', warranty: '12 Months'),
      const LockedPartItem(name: 'Compact Vehicle First Aid Medical Box', mrp: '₹350', coopPrice: '₹190', warranty: '12 Months'),
    ],
  };

  /// Retrieve category-specific locked parts list
  static List<LockedPartItem> getPartsForCategory(String? category, String? serviceName) {
    final catKey = (category ?? '').toLowerCase().trim();
    final nameKey = (serviceName ?? '').toLowerCase().trim();

    // Specific match for Plumbing
    if (catKey.contains('plumb') || nameKey.contains('tap') || nameKey.contains('pipe') || nameKey.contains('drain') || nameKey.contains('water') || nameKey.contains('commode') || nameKey.contains('diverter')) {
      return _categoryParts['plumbing']!;
    }

    // Electrical
    if (catKey.contains('elect') || nameKey.contains('fan') || nameKey.contains('light') || nameKey.contains('switch') || nameKey.contains('wiring') || nameKey.contains('mcb') || nameKey.contains('ev')) {
      return _categoryParts['electrical']!;
    }

    // Appliance Repair
    if (catKey.contains('appliance') || nameKey.contains('ac') || nameKey.contains('refrigerator') || nameKey.contains('washing') || nameKey.contains('chimney') || nameKey.contains('microwave') || nameKey.contains('geyser')) {
      return _categoryParts['appliance repair']!;
    }

    // Carpentry
    if (catKey.contains('carpent') || nameKey.contains('door') || nameKey.contains('window') || nameKey.contains('furniture') || nameKey.contains('lock') || nameKey.contains('hinge') || nameKey.contains('polish')) {
      return _categoryParts['carpentry']!;
    }

    // Painting
    if (catKey.contains('paint') || nameKey.contains('seepage') || nameKey.contains('waterproof') || nameKey.contains('putty')) {
      return _categoryParts['painting']!;
    }

    // Cleaning
    if (catKey.contains('clean') || nameKey.contains('pest') || nameKey.contains('sofa') || nameKey.contains('cockroach')) {
      return _categoryParts['cleaning']!;
    }

    // Gardening
    if (catKey.contains('garden') || nameKey.contains('lawn') || nameKey.contains('terrace')) {
      return _categoryParts['gardening']!;
    }

    // Caregiving
    if (catKey.contains('care') || catKey.contains('health') || nameKey.contains('elderly') || nameKey.contains('nursing') || nameKey.contains('attendant')) {
      return _categoryParts['caregiving']!;
    }

    // Driving
    if (catKey.contains('driv') || nameKey.contains('chauffeur')) {
      return _categoryParts['driving']!;
    }

    return _categoryParts['plumbing']!;
  }
}
