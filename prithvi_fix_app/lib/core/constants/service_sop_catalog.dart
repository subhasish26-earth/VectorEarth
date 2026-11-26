import 'app_images.dart';

class SopStep {
  final int step;
  final String title;
  final String sentence;
  final ImageAssetInfo imageInfo;

  const SopStep({
    required this.step,
    required this.title,
    required this.sentence,
    required this.imageInfo,
  });
}

class ServiceSopData {
  final String serviceName;
  final List<String> equipment;
  final List<SopStep> steps;

  const ServiceSopData({
    required this.serviceName,
    required this.equipment,
    required this.steps,
  });
}

class ServiceSopCatalog {
  static final Map<String, ServiceSopData> _catalog = {
    // 1. AC Gas Leak Repair & Refilling
    'AC Gas Leak Repair & Refilling': ServiceSopData(
      serviceName: 'AC Gas Leak Repair & Refilling',
      equipment: [
        'Digital refrigerant manifold gauge set',
        'Electronic refrigerant leak detector',
        'Dry nitrogen cylinder with regulator',
        'Two-stage vacuum pump and micron gauge',
        'Refrigerant weighing scale',
        'Refrigerant recovery machine and recovery cylinder',
        'Brazing torch, suitable alloy and fire-resistant PPE',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Inspection',
          sentence: 'Check cooling performance, refrigerant connections, service valves, copper pipes and visible oil marks.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Leak Detection',
          sentence: 'Use an electronic leak detector and approved leak-test procedure to identify the exact leakage point.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Leak Repair',
          sentence: 'Repair or replace the damaged pipe, joint or valve using the manufacturer\'s approved method.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Evacuation & Refrigerant Charging',
          sentence: 'Perform the specified pressure test, evacuation and refrigerant charging by weight according to the equipment nameplate.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Performance Verification',
          sentence: 'Check for leaks, cooling performance, operating pressures, electrical load and condensate drainage; record results and issue service confirmation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 2. Double-Door Refrigerator Cooling & Gas Charge
    'Double-Door Refrigerator Cooling & Gas Charge': ServiceSopData(
      serviceName: 'Double-Door Refrigerator Cooling & Gas Charge',
      equipment: [
        'Digital temperature probe',
        'Refrigeration manifold gauge',
        'Electronic leak detector',
        'Refrigerant recovery machine',
        'Vacuum pump and micron gauge',
        'Refrigerant weighing scale',
        'Multimeter and clamp meter',
        'Insulated hand tools',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Cooling Diagnosis',
          sentence: 'Check freezer and refrigerator temperatures, compressor operation, airflow and cooling complaints.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Component Inspection',
          sentence: 'Inspect evaporator, condenser, fans, thermostat, sensors, defrost system and electrical connections.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Leak & Fault Detection',
          sentence: 'Check the sealed refrigerant system for leakage and inspect suspected electrical or mechanical faults.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Refrigerant Restoration',
          sentence: 'Replace defective components and perform refrigerant-system repair, evacuation and charging where required.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Final Cooling Test',
          sentence: 'Verify temperature stability, compressor operation, door sealing, defrost operation and airflow.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 3. Fully-Automatic Washing Machine Repair
    'Fully-Automatic Washing Machine Repair': ServiceSopData(
      serviceName: 'Fully-Automatic Washing Machine Repair',
      equipment: [
        'Digital multimeter',
        'Insulated screwdriver set',
        'Adjustable spanner and socket set',
        'Water-pressure tester',
        'Drain cleaning pump',
        'Bearing and seal removal tools',
        'Replacement hoses, clamps and compatible spare parts',
        'Waterproof service mat',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Diagnosis',
          sentence: 'Check error codes, power supply, water inlet, drainage and customer-reported symptoms.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Mechanical Inspection',
          sentence: 'Examine drum, bearings, suspension, belt, motor and door-lock mechanism.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Electrical Inspection',
          sentence: 'Test PCB, sensors, inlet valve, drain pump and motor connections.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Component Replacement',
          sentence: 'Repair or replace the identified faulty components using compatible parts.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Trial Operation',
          sentence: 'Run appropriate wash, rinse and spin tests; check vibration, drainage, water leakage and noise.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 4. Inverter AC PCB Diagnostics & Repair
    'Inverter AC PCB Diagnostics & Repair': ServiceSopData(
      serviceName: 'Inverter AC PCB Diagnostics & Repair',
      equipment: [
        'Digital multimeter',
        'Clamp meter',
        'Oscilloscope',
        'Insulated electronic repair toolkit',
        'ESD protection mat and wrist strap',
        'Soldering and desoldering station',
        'Thermal camera or infrared thermometer',
        'Manufacturer-approved diagnostic equipment',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Error Code Inspection',
          sentence: 'Record fault codes and inspect indoor and outdoor unit symptoms.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Electrical Diagnosis',
          sentence: 'Check power supply, wiring, fuses, connectors and sensor readings.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'PCB Testing',
          sentence: 'Inspect the control board, communication circuit and power components using appropriate diagnostic instruments.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'PCB Repair or Replacement',
          sentence: 'Repair or replace defective components only where technically appropriate and permitted by the manufacturer.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'System Commissioning',
          sentence: 'Reassemble, restore power safely and verify communication, compressor operation and cooling performance.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 5. Kitchen Chimney & Hob Deep Degreasing
    'Kitchen Chimney & Hob Deep Degreasing': ServiceSopData(
      serviceName: 'Kitchen Chimney & Hob Deep Degreasing',
      equipment: [
        'Industrial degreasing spray',
        'Non-abrasive cleaning brushes',
        'Filter removal toolkit',
        'Steam cleaning machine',
        'Microfiber cloths',
        'Wet and dry vacuum cleaner',
        'Protective gloves and safety goggles',
        'Food-safe surface cleaning solution',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Inspection',
          sentence: 'Examine chimney filters, suction, blower, duct and hob surface condition.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Safety Preparation',
          sentence: 'Isolate electrical power and allow hot surfaces to cool; protect nearby kitchen surfaces.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Filter & Component Cleaning',
          sentence: 'Remove compatible filters and clean grease deposits from accessible components.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Hob & Surface Degreasing',
          sentence: 'Clean burners or compatible hob components according to the manufacturer\'s instructions; avoid flooding electrical parts.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Performance Verification',
          sentence: 'Refit components, check suction, inspect burner operation where applicable and clean the surrounding area.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 6. Microwave Oven Magnetron & Touchpad Service
    'Microwave Oven Magnetron & Touchpad Service': ServiceSopData(
      serviceName: 'Microwave Oven Magnetron & Touchpad Service',
      equipment: [
        'Insulated screwdriver set',
        'Digital multimeter',
        'Microwave leakage detector',
        'ESD protection equipment',
        'Manufacturer-compatible replacement parts',
        'Non-contact temperature measuring instrument',
        'Microwave-safe test container',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Diagnosis',
          sentence: 'Check display, touchpad, heating performance, door operation and error codes.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'External Safety Inspection',
          sentence: 'Inspect the power cord, door hinges, latch and cabinet condition.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Component Diagnosis',
          sentence: 'A qualified microwave technician checks the control board, switches and high-voltage components.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Replacement',
          sentence: 'Replace defective components using manufacturer-approved parts and procedures.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Safety & Performance Testing',
          sentence: 'Verify door interlocks, microwave leakage, heating performance and correct touchpad operation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 7. Split AC Deep Jet Cleaning & Service
    'Split AC Deep Jet Cleaning & Service': ServiceSopData(
      serviceName: 'Split AC Deep Jet Cleaning & Service',
      equipment: [
        'AC indoor-unit cleaning bag',
        'Adjustable-pressure cleaning pump',
        'Coil-safe cleaning solution',
        'Fin cleaning brush',
        'Wet and dry vacuum cleaner',
        'Drain flushing pump',
        'Digital thermometer',
        'Protective gloves and safety goggles',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Pre-Service Inspection',
          sentence: 'Check cooling, airflow, filters, coils, blower and drainage.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Unit Preparation',
          sentence: 'Isolate electrical supply, cover nearby furniture and install the waterproof cleaning bag.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Chemical Cleaning',
          sentence: 'Apply compatible coil-cleaning solution to filters, evaporator coils and blower.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Controlled Jet Washing',
          sentence: 'Clean coils and blower using suitable pressure without damaging fins or electrical components.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Final Testing',
          sentence: 'Flush the drain, dry accessible surfaces, reassemble and verify airflow, cooling and drainage.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 8. Split AC Installation (New/Relocation)
    'Split AC Installation (New/Relocation)': ServiceSopData(
      serviceName: 'Split AC Installation (New/Relocation)',
      equipment: [
        'Rotary hammer drill and core-cutting tools',
        'AC installation mounting bracket',
        'Digital spirit level',
        'Copper pipe flaring and bending toolkit',
        'Torque wrench',
        'Nitrogen cylinder and regulator',
        'Vacuum pump and micron gauge',
        'Refrigerant leak detector',
        'Electrical testing instruments',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Site Assessment',
          sentence: 'Select suitable indoor and outdoor locations, checking ventilation, drainage and structural support.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Mounting & Drilling',
          sentence: 'Install mounting plates and approved outdoor-unit supports; create the pipe and drain route.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Copper & Electrical Connections',
          sentence: 'Route and connect refrigerant pipes, drain hose and correctly rated electrical connections.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Pressure Test & Commissioning',
          sentence: 'Conduct the specified leak test and evacuation; release or charge refrigerant according to manufacturer instructions.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Installation Audit',
          sentence: 'Verify cooling, drainage, vibration, electrical safety and remote-control operation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 9. Elderly Bedside Attendant (Daily Day Care)
    'Elderly Bedside Attendant (Daily Day Care)': ServiceSopData(
      serviceName: 'Elderly Bedside Attendant (Daily Day Care)',
      equipment: [
        'Adjustable patient-care bed accessories',
        'Digital thermometer',
        'Digital blood pressure monitor',
        'Pulse oximeter',
        'Disposable gloves and medical masks',
        'Hand sanitiser',
        'Bedpan and urinal',
        'Patient transfer belt',
        'Personal hygiene and grooming supplies',
        'Patient-care observation register',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Patient Handover',
          sentence: 'Understand the patient\'s routine, mobility, dietary instructions and care requirements from the family.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Vital Sign Monitoring',
          sentence: 'Record temperature, blood pressure, pulse and oxygen saturation when included in the care plan.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Daily Personal Care',
          sentence: 'Assist with bathing, grooming, dressing, toileting and hygiene while maintaining dignity.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Mobility & Companionship',
          sentence: 'Assist with safe movement, prescribed exercises and meals; monitor changes in the patient\'s condition.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Daily Reporting',
          sentence: 'Record care activities, food intake, observations and concerns; hand over to the family.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 10. Post-Operative Dressing & Injection Nursing Visit
    'Post-Operative Dressing & Injection Nursing Visit': ServiceSopData(
      serviceName: 'Post-Operative Dressing & Injection Nursing Visit',
      equipment: [
        'Sterile dressing tray',
        'Sterile gauze and dressing materials',
        'Medical-grade gloves and masks',
        'Skin antiseptic approved for the procedure',
        'Sterile saline where prescribed',
        'Medical waste disposal bags',
        'Sharps disposal container',
        'Sterile syringes and needles, where prescribed',
        'Patient observation chart',
        'Emergency contact information',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Patient Verification',
          sentence: 'Confirm patient identity, prescription, allergies, procedure and medical history.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Hand Hygiene & Preparation',
          sentence: 'Prepare a clean clinical workspace and maintain sterile technique.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Dressing Procedure',
          sentence: 'Assess the wound and perform dressing changes according to the clinician\'s instructions.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Prescribed Injection',
          sentence: 'Administer only a validly prescribed injection by an appropriately qualified registered healthcare professional.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Post-Procedure Monitoring',
          sentence: 'Observe for adverse reactions, document the procedure and provide follow-up instructions.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 11. Aluminium Sliding Window Roller & Track Overhaul
    'Aluminium Sliding Window Roller & Track Overhaul': ServiceSopData(
      serviceName: 'Aluminium Sliding Window Roller & Track Overhaul',
      equipment: [
        'Screwdriver and hex key set',
        'Roller removal tools',
        'Replacement rollers and compatible fittings',
        'Track cleaning brush',
        'Silicone-based lubricant suitable for the system',
        'Digital spirit level',
        'Vacuum cleaner',
        'Protective gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Window Inspection',
          sentence: 'Check sliding resistance, frame alignment, rollers, tracks and locking mechanism.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Panel Removal',
          sentence: 'Secure and carefully remove the sliding panel using appropriate lifting assistance.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Track Restoration',
          sentence: 'Remove dirt, debris and damaged components from the track.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Roller Replacement',
          sentence: 'Install compatible rollers, adjust their height and align the window panel.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Glide & Lock Testing',
          sentence: 'Verify smooth sliding, secure locking, alignment and weather-seal contact.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 12. Flatpack Furniture Assembly (Bed, Wardrobe, Desk)
    'Flatpack Furniture Assembly (Bed, Wardrobe, Desk)': ServiceSopData(
      serviceName: 'Flatpack Furniture Assembly (Bed, Wardrobe, Desk)',
      equipment: [
        'Cordless screwdriver',
        'Allen key set',
        'Screwdriver set',
        'Rubber mallet',
        'Measuring tape',
        'Digital spirit level',
        'Furniture assembly clamps',
        'Stud and wall-anchor detector',
        'Furniture assembly toolkit',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Component Inspection',
          sentence: 'Verify all panels, fittings, fasteners and assembly instructions.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Workspace Preparation',
          sentence: 'Arrange components, protect flooring and identify the assembly location.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Frame Assembly',
          sentence: 'Assemble the main structure using the supplied fittings and recommended sequence.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Alignment & Securing',
          sentence: 'Align panels, install hinges, drawers and handles, and anchor tall furniture where required.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Stability Testing',
          sentence: 'Check structural stability, drawer movement, door alignment and overall finish.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 13. High-Security Main Door Mortise Lock Fitting
    'High-Security Main Door Mortise Lock Fitting': ServiceSopData(
      serviceName: 'High-Security Main Door Mortise Lock Fitting',
      equipment: [
        'Mortise lock installation kit',
        'Cordless drill',
        'Wood chisels',
        'Router with suitable template',
        'Measuring tape and marking gauge',
        'Drill bits and hole saw',
        'Screwdriver set',
        'Digital spirit level',
        'Compatible lock and fasteners',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Door Assessment',
          sentence: 'Measure door thickness, lock position, backset and existing hardware.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Marking & Layout',
          sentence: 'Mark the mortise, cylinder, handle and strike-plate positions.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Lock Cavity Preparation',
          sentence: 'Carefully prepare the required cavities without weakening the door structure.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Lock Installation',
          sentence: 'Fit the mortise body, cylinder, handles and strike plate.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Security Testing',
          sentence: 'Check key operation, latch movement, deadbolt engagement and door alignment.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 14. Modular Kitchen Soft-Close Hydraulic Hinge Upgrade
    'Modular Kitchen Soft-Close Hydraulic Hinge Upgrade': ServiceSopData(
      serviceName: 'Modular Kitchen Soft-Close Hydraulic Hinge Upgrade',
      equipment: [
        'Cordless screwdriver',
        'Hinge drilling jig',
        'Forstner drill bit',
        'Measuring tape',
        'Digital spirit level',
        'Cabinet clamps',
        'Replacement hydraulic hinges',
        'Compatible screws and mounting plates',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Cabinet Inspection',
          sentence: 'Examine existing hinges, door condition, cabinet alignment and closing behaviour.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Hinge Removal',
          sentence: 'Remove old hinges and inspect mounting locations.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Cup Preparation',
          sentence: 'Prepare hinge cup locations using the appropriate drilling template where necessary.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'New Hinge Installation',
          sentence: 'Fit compatible hydraulic hinges and adjust mounting plates.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Soft-Close Testing',
          sentence: 'Verify smooth closing, consistent gaps and proper cabinet-door alignment.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 15. Premium French Spirit & Wood PU Clear Polish
    'Premium French Spirit & Wood PU Clear Polish': ServiceSopData(
      serviceName: 'Premium French Spirit & Wood PU Clear Polish',
      equipment: [
        'Orbital sanding machine',
        'Sandpaper of appropriate grit',
        'Wood putty and filler',
        'Dust extraction vacuum',
        'Spray gun and air compressor',
        'Polish applicators',
        'Surface moisture meter',
        'Respirator and chemical-resistant gloves',
        'Suitable ventilation and fire-safety equipment',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Surface Inspection',
          sentence: 'Identify scratches, cracks, old coatings, moisture damage and wood condition.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Clean, fill imperfections and sand the wood to the required finish.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Dust Removal',
          sentence: 'Remove sanding dust and prepare the surface for coating.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Polish Application',
          sentence: 'Apply the selected French polish or PU coating following the product\'s application and curing instructions.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Finishing Inspection',
          sentence: 'Check smoothness, gloss consistency, coverage and curing before handing over.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 16. Wooden Door Planing, Trimming & Floor Clearance
    'Wooden Door Planing, Trimming & Floor Clearance': ServiceSopData(
      serviceName: 'Wooden Door Planing, Trimming & Floor Clearance',
      equipment: [
        'Electric hand planer',
        'Circular saw or track saw',
        'Wood chisel set',
        'Measuring tape',
        'Digital spirit level',
        'Carpenter\'s square',
        'Door lifting support',
        'Sanding machine',
        'Dust extraction vacuum',
        'Safety goggles and hearing protection',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Clearance Inspection',
          sentence: 'Identify rubbing points, floor clearance, door alignment and hinge condition.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Measurement & Marking',
          sentence: 'Mark the required trimming area after checking floor slope and door movement.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Door Removal',
          sentence: 'Safely remove and support the door where necessary.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Planing & Trimming',
          sentence: 'Remove excess material gradually and smooth the cut edges.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Reinstallation',
          sentence: 'Refit the door, adjust hinges and verify free movement and appropriate clearance.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 17. Bathroom Acid-Free Descaling & Grout Restoration
    'Bathroom Acid-Free Descaling & Grout Restoration': ServiceSopData(
      serviceName: 'Bathroom Acid-Free Descaling & Grout Restoration',
      equipment: [
        'Wet and dry vacuum cleaner',
        'Grout cleaning brush',
        'Rotary scrubber with suitable brush',
        'Acid-free descaling solution',
        'Grout restoration compound',
        'Microfiber cloths',
        'Spray bottles',
        'Protective gloves and goggles',
        'Wet-floor warning sign',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Surface Inspection',
          sentence: 'Examine tiles, grout lines, hard-water deposits and bathroom fittings.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Dry Cleaning',
          sentence: 'Remove loose dust and debris from corners, tile joints and surfaces.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Descaling Treatment',
          sentence: 'Apply a compatible acid-free cleaning solution and allow the recommended dwell time.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Grout Restoration',
          sentence: 'Scrub grout lines, remove residue and repair damaged grout where included in the service.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Final Cleaning',
          sentence: 'Rinse or wipe surfaces as directed, dry the floor and inspect the finish.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 18. Full Apartment Deep Machine Cleaning
    'Full Apartment Deep Machine Cleaning': ServiceSopData(
      serviceName: 'Full Apartment Deep Machine Cleaning',
      equipment: [
        'Industrial wet and dry vacuum cleaner',
        'Single-disc floor scrubbing machine',
        'Steam cleaner',
        'Microfiber mop system',
        'Extension cleaning poles',
        'Glass cleaning squeegee',
        'Floor-safe cleaning chemicals',
        'HEPA-filter vacuum',
        'Protective gloves and masks',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Apartment Assessment',
          sentence: 'Inspect rooms, floors, windows, furniture and areas requiring special attention.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Dry Dust Extraction',
          sentence: 'Remove dust from ceilings, fans, furniture, corners and surfaces.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Machine Deep Cleaning',
          sentence: 'Use suitable machines and cleaning solutions for floors and other compatible surfaces.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Detail Cleaning',
          sentence: 'Clean kitchens, bathrooms, windows, fixtures and frequently touched surfaces.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Final Inspection',
          sentence: 'Remove cleaning residue, dry surfaces, reposition furniture and conduct a room-by-room checklist.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 19. Intensive Kitchen Oil & Grease Descaling
    'Intensive Kitchen Oil & Grease Descaling': ServiceSopData(
      serviceName: 'Intensive Kitchen Oil & Grease Descaling',
      equipment: [
        'Industrial kitchen degreaser',
        'Steam cleaning machine',
        'Non-abrasive scrubbing brushes',
        'Microfiber cloths',
        'Wet and dry vacuum cleaner',
        'Scraper tools suitable for the surface',
        'Protective gloves and goggles',
        'Food-contact surface-safe rinsing materials',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Kitchen Assessment',
          sentence: 'Identify grease accumulation on tiles, chimney exteriors, cabinets and worktops.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Area Preparation',
          sentence: 'Cover food, utensils and appliances; isolate electrical equipment where necessary.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Degreasing Application',
          sentence: 'Apply compatible degreaser to affected surfaces.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Mechanical Cleaning',
          sentence: 'Scrub grease deposits and extract loosened residue without damaging finishes.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Hygiene Verification',
          sentence: 'Rinse food-contact surfaces appropriately, dry the area and verify grease removal.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 20. Odorless Herbal Gel Cockroach & Pest Barrier
    'Odorless Herbal Gel Cockroach & Pest Barrier': ServiceSopData(
      serviceName: 'Odorless Herbal Gel Cockroach & Pest Barrier',
      equipment: [
        'Approved gel bait applicator',
        'Pest inspection flashlight',
        'Inspection mirror',
        'Cockroach monitoring glue traps',
        'Crack and crevice inspection tools',
        'Protective gloves',
        'Approved pest-control products',
        'Treatment record sheet',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Pest Inspection',
          sentence: 'Identify pest activity, entry points, harbourage areas and infestation severity.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Site Preparation',
          sentence: 'Explain safety precautions and identify food, utensils, children and pet access areas.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Targeted Gel Application',
          sentence: 'Apply approved gel bait at suitable locations according to product label directions.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Monitoring & Prevention',
          sentence: 'Place monitoring traps and recommend sanitation and entry-point control.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Follow-Up Inspection',
          sentence: 'Review trap activity, document treatment and arrange additional treatment if required.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 21. Sofa & Mattress Foam Shampoo & Extraction Wash
    'Sofa & Mattress Foam Shampoo & Extraction Wash': ServiceSopData(
      serviceName: 'Sofa & Mattress Foam Shampoo & Extraction Wash',
      equipment: [
        'Upholstery extraction machine',
        'Foam shampoo applicator',
        'Upholstery-safe cleaning solution',
        'Soft-bristle upholstery brushes',
        'Wet vacuum extractor',
        'Microfiber towels',
        'Fabric moisture meter',
        'Air movers or drying fans',
        'Protective gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Fabric Inspection',
          sentence: 'Identify fabric type, stains, colour-fastness and cleaning restrictions.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Dry Vacuuming',
          sentence: 'Remove loose dust, hair and debris from the sofa or mattress.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Foam Application',
          sentence: 'Apply a suitable upholstery cleaning solution after a compatibility test.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Agitation & Extraction',
          sentence: 'Gently brush the fabric and extract loosened dirt and cleaning residue.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Drying & Final Check',
          sentence: 'Allow proper drying, inspect stain removal and verify fabric condition.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 22. Outstation Long-Distance Highway Chauffeur
    'Outstation Long-Distance Highway Chauffeur': ServiceSopData(
      serviceName: 'Outstation Long-Distance Highway Chauffeur',
      equipment: [
        'Valid driving licence',
        'Vehicle registration and insurance documents',
        'Vehicle first-aid kit',
        'Reflective safety triangle',
        'Reflective safety jacket',
        'Tyre pressure gauge',
        'Portable tyre inflator',
        'Emergency flashlight',
        'Mobile phone with navigation',
        'Drinking water and emergency contact list',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Trip Confirmation',
          sentence: 'Confirm destination, route, schedule, passenger requirements and vehicle details.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Vehicle Inspection',
          sentence: 'Check tyres, brakes, lights, mirrors, fuel, fluids and essential documents.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Journey Preparation',
          sentence: 'Plan route, rest stops, emergency contacts and expected travel duration.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Safe Journey Execution',
          sentence: 'Follow traffic rules, speed limits, passenger instructions and mandatory rest requirements.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Trip Completion',
          sentence: 'Park safely, confirm passenger arrival and report trip completion.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 23. Professional City Chauffeur (8-Hour Shift)
    'Professional City Chauffeur (8-Hour Shift)': ServiceSopData(
      serviceName: 'Professional City Chauffeur (8-Hour Shift)',
      equipment: [
        'Valid driving licence',
        'Mobile navigation device',
        'Vehicle first-aid kit',
        'Vehicle emergency toolkit',
        'Reflective safety jacket',
        'Tyre pressure gauge',
        'Phone charging equipment',
        'Trip logbook',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Shift Briefing',
          sentence: 'Confirm pickup location, passenger schedule and assigned vehicle.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Vehicle Readiness',
          sentence: 'Inspect tyres, brakes, lights, fuel and cleanliness.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Passenger Pickup',
          sentence: 'Arrive at the designated location and verify the booking.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'City Driving',
          sentence: 'Follow navigation, road rules and scheduled passenger stops.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Shift Handover',
          sentence: 'Record completed trips, fuel status, vehicle condition and pending requirements.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 24. Ceiling Fan Installation & Overhaul
    'Ceiling Fan Installation & Overhaul': ServiceSopData(
      serviceName: 'Ceiling Fan Installation & Overhaul',
      equipment: [
        'Insulated screwdriver set',
        'Digital multimeter',
        'Clamp meter',
        'Voltage tester',
        'Drill machine',
        'Appropriate ceiling anchors and fasteners',
        'Spanner set',
        'Ladder',
        'Insulated gloves',
        'Safety helmet',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Site Inspection',
          sentence: 'Check ceiling strength, mounting point, existing wiring and fan compatibility.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Power Isolation',
          sentence: 'Disconnect the electrical supply and verify absence of voltage.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Mounting Preparation',
          sentence: 'Install an appropriately rated fan hook or mounting bracket.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Electrical & Mechanical Installation',
          sentence: 'Connect wiring correctly and assemble the fan according to manufacturer instructions.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Operational Testing',
          sentence: 'Restore power and verify rotation, speed control, balance, vibration and secure mounting.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 25. Chandelier & Designer Pendant Light Fitting
    'Chandelier & Designer Pendant Light Fitting': ServiceSopData(
      serviceName: 'Chandelier & Designer Pendant Light Fitting',
      equipment: [
        'Heavy-duty ladder or suitable access platform',
        'Insulated screwdriver set',
        'Digital multimeter',
        'Voltage tester',
        'Rotary hammer drill',
        'Ceiling anchor and fastener kit',
        'Torque-controlled screwdriver',
        'Cable support and suspension hardware',
        'Laser level',
        'Safety harness and helmet where required',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Ceiling & Load Assessment',
          sentence: 'Inspect ceiling material, structural support, fixture weight and mounting location.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Mounting Preparation',
          sentence: 'Mark the position and install appropriately rated anchors or structural supports.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Fixture Assembly',
          sentence: 'Assemble chandelier sections and prepare suspension cables according to the manufacturer\'s instructions.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Electrical Connection & Suspension',
          sentence: 'Isolate power, connect wiring correctly and secure the fixture to the rated support.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Alignment & Safety Testing',
          sentence: 'Verify level, secure suspension, electrical operation, illumination and customer-approved positioning.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 26. Complete House Concealed Rewiring
    'Complete House Concealed Rewiring': ServiceSopData(
      serviceName: 'Complete House Concealed Rewiring',
      equipment: [
        'Insulation resistance tester',
        'Digital multimeter',
        'Clamp meter',
        'Voltage tester',
        'Wall chasing machine',
        'Rotary hammer drill',
        'Conduit bending tools',
        'Cable pulling equipment',
        'Wire stripping and crimping tools',
        'Approved electrical cables and accessories',
        'PPE and electrical isolation equipment',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Electrical Assessment',
          sentence: 'Inspect existing wiring, electrical load, circuits, distribution board and building layout.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Circuit Planning',
          sentence: 'Prepare the wiring layout, cable sizing, protective device selection and earthing plan.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Conduit Installation',
          sentence: 'Isolate existing circuits, prepare routes and install suitable conduits and junction boxes.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Cable Installation',
          sentence: 'Pull correctly sized conductors, terminate connections and install protective devices.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Electrical Testing',
          sentence: 'Perform insulation resistance, continuity, polarity, earthing and protective-device checks before energising.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 27. Electric Geyser Fast Heating Diagnostic & Repair
    'Electric Geyser Fast Heating Diagnostic & Repair': ServiceSopData(
      serviceName: 'Electric Geyser Fast Heating Diagnostic & Repair',
      equipment: [
        'Digital multimeter',
        'Clamp meter',
        'Insulated screwdriver set',
        'Insulation resistance tester',
        'Temperature probe',
        'Pressure gauge',
        'Adjustable spanner',
        'Compatible heating element and thermostat',
        'Electrical PPE',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Diagnosis',
          sentence: 'Check heating time, water temperature, indicator lights and customer complaints.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Electrical Isolation',
          sentence: 'Disconnect power and verify the appliance is safe to service.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Component Inspection',
          sentence: 'Inspect heating element, thermostat, wiring, thermal cut-out and water connections.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Replacement',
          sentence: 'Replace defective components with manufacturer-compatible parts and check for leaks.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Operational Testing',
          sentence: 'Verify safe filling, heating performance, thermostat operation, earthing and leakage protection.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 28. Emergency Electrical Short Circuit Diagnostics
    'Emergency Electrical Short Circuit Diagnostics': ServiceSopData(
      serviceName: 'Emergency Electrical Short Circuit Diagnostics',
      equipment: [
        'CAT-rated digital multimeter',
        'Insulation resistance tester',
        'Clamp meter',
        'Non-contact voltage detector',
        'Insulated hand tools',
        'Circuit tracing equipment',
        'Lockout/tagout kit',
        'Electrical safety gloves',
        'Safety helmet and protective footwear',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Emergency Assessment',
          sentence: 'Identify smoke, burning smell, sparks, affected circuits and immediate hazards.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Power Isolation',
          sentence: 'Disconnect the affected supply safely and prevent accidental re-energisation.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Fault Location',
          sentence: 'Inspect wiring, switches, sockets, junction boxes and electrical appliances.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Fault Rectification',
          sentence: 'Repair or replace damaged conductors and components using correctly rated materials.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Safety Verification',
          sentence: 'Perform electrical testing, confirm protective-device operation and restore supply only when safe.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 29. EV Four-Wheeler Home Charger Line (7.4kW)
    'EV Four-Wheeler Home Charger Line (7.4kW)': ServiceSopData(
      serviceName: 'EV Four-Wheeler Home Charger Line (7.4kW)',
      equipment: [
        'Digital multimeter',
        'Clamp meter',
        'Insulation resistance tester',
        'Earth resistance tester',
        'Cable sizing and installation toolkit',
        'Conduit and cable gland accessories',
        'Torque screwdriver',
        'Manufacturer-approved EVSE installation tools',
        'Lockout/tagout kit',
        'Electrical PPE',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Load Assessment',
          sentence: 'Inspect the existing supply, sanctioned load, distribution board and proposed charger location.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Installation Planning',
          sentence: 'Determine cable size, protective devices, earthing and installation route according to applicable standards.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Dedicated Circuit Installation',
          sentence: 'Install the correctly rated dedicated cable, conduit and protective equipment.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Charger Mounting & Connection',
          sentence: 'Mount the compatible EV charger and complete the electrical connections.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Commissioning',
          sentence: 'Verify earthing, insulation, protection, charging communication and charging operation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 30. Inverter & Battery Home Wiring Setup
    'Inverter & Battery Home Wiring Setup': ServiceSopData(
      serviceName: 'Inverter & Battery Home Wiring Setup',
      equipment: [
        'Digital multimeter',
        'DC clamp meter',
        'Battery terminal crimping tool',
        'Cable cutter and stripper',
        'Insulated spanner set',
        'Battery interconnection cables',
        'DC fuse and isolator',
        'Battery terminal protection covers',
        'Eye protection and insulated gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Load Assessment',
          sentence: 'Identify essential loads, inverter capacity, battery voltage and backup requirements.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Installation Planning',
          sentence: 'Select suitable cables, protective devices, ventilation and mounting positions.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Inverter Installation',
          sentence: 'Secure the inverter and install the required AC and DC isolation equipment.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Battery Connection',
          sentence: 'Connect compatible batteries using the correct polarity, cable size and protective devices.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'System Testing',
          sentence: 'Verify charging, backup transfer, output voltage, earthing and battery performance.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 31. Main MCB & Distribution Board Replacement
    'Main MCB & Distribution Board Replacement': ServiceSopData(
      serviceName: 'Main MCB & Distribution Board Replacement',
      equipment: [
        'CAT-rated multimeter',
        'Clamp meter',
        'Insulation resistance tester',
        'Insulated screwdriver set',
        'Wire stripping and crimping tools',
        'Torque screwdriver',
        'Circuit labelling kit',
        'Compatible MCBs and distribution board',
        'Lockout/tagout kit',
        'Electrical PPE',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Board Inspection',
          sentence: 'Examine circuit layout, existing MCB ratings, wiring condition and load distribution.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Power Isolation',
          sentence: 'Disconnect the incoming supply and verify absence of voltage.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Board Replacement',
          sentence: 'Remove the old board and install a correctly rated replacement.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Circuit Reconnection',
          sentence: 'Connect and label each circuit with suitable protective devices.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Electrical Testing',
          sentence: 'Verify connections, insulation, polarity, earthing and protective-device operation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 32. Switch, Socket & Modular Plate Replacement
    'Switch, Socket & Modular Plate Replacement': ServiceSopData(
      serviceName: 'Switch, Socket & Modular Plate Replacement',
      equipment: [
        'Insulated screwdriver set',
        'Digital multimeter',
        'Voltage tester',
        'Wire stripper',
        'Insulated pliers',
        'Screwdriver torque tool',
        'Compatible switches and sockets',
        'Electrical insulation accessories',
        'Electrical safety gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Inspection',
          sentence: 'Identify the defective switch, socket, plate or loose connection.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Power Isolation',
          sentence: 'Disconnect the relevant circuit and verify absence of voltage.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Old Component Removal',
          sentence: 'Remove the damaged plate and inspect wiring and mounting boxes.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Replacement & Connection',
          sentence: 'Install compatible components and tighten terminals according to specifications.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Functionality Test',
          sentence: 'Restore power and verify switching, polarity, socket operation and secure mounting.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 33. Lawn Mowing & Landscape Shrub Pruning
    'Lawn Mowing & Landscape Shrub Pruning': ServiceSopData(
      serviceName: 'Lawn Mowing & Landscape Shrub Pruning',
      equipment: [
        'Lawn mower',
        'Grass trimmer',
        'Hedge trimmer',
        'Pruning shears',
        'Loppers',
        'Garden rake',
        'Leaf blower',
        'Garden waste bags',
        'Protective gloves and safety goggles',
        'Safety footwear',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Garden Inspection',
          sentence: 'Assess lawn height, grass condition, shrub growth and potential hazards.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Area Preparation',
          sentence: 'Remove stones, branches and debris from the working area.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Lawn Mowing',
          sentence: 'Cut grass evenly using suitable mower settings.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Shrub Pruning',
          sentence: 'Trim overgrown branches and shape shrubs without damaging plant structure.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Garden Restoration',
          sentence: 'Collect clippings, remove debris and inspect the finished landscape.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 34. Terrace Garden Micro Drip Automation Setup
    'Terrace Garden Micro Drip Automation Setup': ServiceSopData(
      serviceName: 'Terrace Garden Micro Drip Automation Setup',
      equipment: [
        'Drip irrigation pipes',
        'Micro-drip emitters',
        'Water filter',
        'Pressure regulator',
        'Solenoid valve',
        'Automatic irrigation controller',
        'Water timer and moisture sensors',
        'Pipe cutter',
        'Connectors and end caps',
        'Pressure testing equipment',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Terrace Assessment',
          sentence: 'Map plant locations, water source, available pressure and irrigation requirements.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'System Design',
          sentence: 'Plan pipe routes, emitter locations, filtration and controller placement.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Pipe Installation',
          sentence: 'Install the main supply line, distribution pipes and micro-drip emitters.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Automation Setup',
          sentence: 'Connect the controller, valves and sensors; configure watering schedules.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Performance Testing',
          sentence: 'Test pressure, emitter flow, leakage, timer operation and plant coverage.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 35. Exterior Anti-Fungal Weathercoat Painting
    'Exterior Anti-Fungal Weathercoat Painting': ServiceSopData(
      serviceName: 'Exterior Anti-Fungal Weathercoat Painting',
      equipment: [
        'High-pressure surface washer',
        'Scraper and wire brush',
        'Exterior wall primer',
        'Anti-fungal treatment',
        'Paint roller and extension pole',
        'Paint spray machine where suitable',
        'Exterior weatherproof coating',
        'Scaffolding or access platform',
        'Safety harness, helmet and respirator',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Wall Inspection',
          sentence: 'Identify cracks, fungal growth, peeling paint and moisture penetration.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Remove loose paint, dirt and fungal deposits using appropriate methods.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Treatment & Priming',
          sentence: 'Apply a compatible anti-fungal treatment and suitable exterior primer.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Weathercoat Application',
          sentence: 'Apply the specified exterior paint in the recommended number of coats.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Final Inspection',
          sentence: 'Check coverage, uniformity, adhesion and drying before removing protective coverings.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 36. Interior Luxury Silk Emulsion Painting
    'Interior Luxury Silk Emulsion Painting': ServiceSopData(
      serviceName: 'Interior Luxury Silk Emulsion Painting',
      equipment: [
        'Paint roller and extension pole',
        'Quality paint brushes',
        'Paint tray',
        'Wall putty',
        'Sanding machine',
        'Sandpaper',
        'Interior primer',
        'Silk emulsion paint',
        'Masking tape and drop-cloths',
        'Dust mask and safety goggles',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Wall Inspection',
          sentence: 'Check cracks, peeling paint, moisture and surface irregularities.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Remove loose paint, repair cracks and sand the wall.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Primer Application',
          sentence: 'Apply a suitable interior primer and allow proper drying.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Paint Application',
          sentence: 'Apply silk emulsion evenly using suitable rollers or brushes.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Finishing Inspection',
          sentence: 'Check colour consistency, finish quality, edges and surface coverage.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 37. Seepage Damp Treatment with Injection Grouting
    'Seepage Damp Treatment with Injection Grouting': ServiceSopData(
      serviceName: 'Seepage Damp Treatment with Injection Grouting',
      equipment: [
        'Moisture meter',
        'Thermal imaging camera where useful',
        'Crack inspection tools',
        'Injection grouting pump',
        'Injection packers',
        'Compatible injection resin or grout',
        'Drill machine',
        'Scraper and surface preparation tools',
        'PPE and chemical-resistant gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Moisture Diagnosis',
          sentence: 'Identify damp patches, crack patterns, seepage sources and affected areas.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Remove loose plaster and prepare the treatment area.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Injection Point Marking',
          sentence: 'Mark suitable injection locations based on the crack and wall condition.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Grouting Application',
          sentence: 'Install packers and inject the specified compatible material under controlled conditions.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Treatment Verification',
          sentence: 'Check for leakage reduction, allow curing and recommend suitable plaster or paint restoration.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 38. Terrace Chemical Elastomeric Waterproofing
    'Terrace Chemical Elastomeric Waterproofing': ServiceSopData(
      serviceName: 'Terrace Chemical Elastomeric Waterproofing',
      equipment: [
        'Pressure washer',
        'Floor scraper',
        'Crack filling compound',
        'Waterproofing primer',
        'Elastomeric waterproof coating',
        'Roller and brush applicators',
        'Thickness measurement gauge',
        'Moisture meter',
        'Safety footwear and gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Terrace Inspection',
          sentence: 'Check cracks, drainage outlets, ponding water and existing waterproofing.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Clean the terrace, remove loose coatings and repair surface defects.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Primer Application',
          sentence: 'Apply a compatible waterproofing primer.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Coating Application',
          sentence: 'Apply elastomeric waterproofing material in the specified number of coats and required coverage.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Waterproofing Verification',
          sentence: 'Allow full curing and conduct an appropriate controlled water test where suitable.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 39. Wall Putty Application & Machine Sanding
    'Wall Putty Application & Machine Sanding': ServiceSopData(
      serviceName: 'Wall Putty Application & Machine Sanding',
      equipment: [
        'Wall sanding machine',
        'HEPA dust extractor',
        'Putty application blades',
        'Putty mixing drill',
        'Mixing paddle',
        'Measuring bucket',
        'Sandpaper',
        'Surface moisture meter',
        'Work platform',
        'Dust mask and safety goggles',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Wall Assessment',
          sentence: 'Inspect unevenness, cracks, dampness and existing coating.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Surface Preparation',
          sentence: 'Remove loose paint, dust and weak plaster.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Putty Preparation',
          sentence: 'Mix suitable wall putty according to the manufacturer\'s instructions.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Application & Sanding',
          sentence: 'Apply uniform putty coats, allow drying and machine-sand to a smooth finish.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Surface Inspection',
          sentence: 'Check smoothness, corners, flatness and readiness for primer and paint.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 40. Automatic Water Booster Pump Installation
    'Automatic Water Booster Pump Installation': ServiceSopData(
      serviceName: 'Automatic Water Booster Pump Installation',
      equipment: [
        'Water pressure gauge',
        'Digital multimeter',
        'Pipe cutter',
        'Pipe threading tools',
        'Adjustable spanner',
        'PTFE sealing tape',
        'Compatible pump and pressure controller',
        'Non-return valve',
        'Isolation valves',
        'Pipe fittings and supports',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Water Supply Assessment',
          sentence: 'Inspect the source, existing pressure, pipe diameter and water demand.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Pump Selection',
          sentence: 'Select an appropriately rated pump based on flow, head and installation requirements.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Pipe Preparation',
          sentence: 'Prepare inlet and outlet lines, supports, valves and non-return protection.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Pump Installation',
          sentence: 'Mount the pump securely and connect plumbing and electrical supply safely.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Commissioning',
          sentence: 'Prime where required and test pressure, flow, leakage, automatic controls and noise.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 41. Bathroom Multi-Flow Concealed Diverter Overhaul
    'Bathroom Multi-Flow Concealed Diverter Overhaul': ServiceSopData(
      serviceName: 'Bathroom Multi-Flow Concealed Diverter Overhaul',
      equipment: [
        'Adjustable spanner',
        'Cartridge removal tool',
        'Allen key set',
        'Screwdriver set',
        'Water pressure gauge',
        'Plumbing inspection mirror',
        'Replacement cartridges and seals',
        'Compatible diverter components',
        'Pipe sealing accessories',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Initial Diagnosis',
          sentence: 'Check water flow, temperature control, leakage and diverter operation.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Water Isolation',
          sentence: 'Shut off the relevant water supply and release line pressure.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Diverter Inspection',
          sentence: 'Remove accessible trim and inspect the cartridge, seals and internal mechanism.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Replacement',
          sentence: 'Clean or replace defective components with compatible parts.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Flow Testing',
          sentence: 'Restore water supply and check outlet selection, pressure, temperature control and leakage.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 42. Blocked Drain & Sewer Pipe De-clogging
    'Blocked Drain & Sewer Pipe De-clogging': ServiceSopData(
      serviceName: 'Blocked Drain & Sewer Pipe De-clogging',
      equipment: [
        'Drain inspection camera',
        'Electric drain auger',
        'Manual drain snake',
        'High-pressure drain jetter',
        'Wet and dry vacuum',
        'Drain access tools',
        'Protective gloves',
        'Face shield and waterproof boots',
        'Waste collection equipment',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Blockage Assessment',
          sentence: 'Identify affected drains, backup symptoms and possible blockage locations.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Drain Inspection',
          sentence: 'Use suitable inspection tools to identify the nature and position of the obstruction.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Blockage Removal',
          sentence: 'Use an appropriate drain snake, auger or controlled jetting method.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Pipe Flushing',
          sentence: 'Flush the affected line and remove loosened debris safely.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Flow Verification',
          sentence: 'Test drainage, check for leaks and provide preventive maintenance recommendations.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 43. Emergency 60-Min Main Pipe Burst Containment
    'Emergency 60-Min Main Pipe Burst Containment': ServiceSopData(
      serviceName: 'Emergency 60-Min Main Pipe Burst Containment',
      equipment: [
        'Pipe repair clamps',
        'Pipe cutter',
        'Adjustable spanner',
        'Pipe wrench',
        'Compatible replacement pipe and fittings',
        'Temporary leak-sealing materials',
        'Water pressure gauge',
        'Water shut-off key',
        'Water extraction pump',
        'Waterproof safety boots and gloves',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Emergency Assessment',
          sentence: 'Locate the burst, assess water damage and identify electrical or structural hazards.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Water Isolation',
          sentence: 'Shut off the nearest appropriate valve or main supply.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Water Containment',
          sentence: 'Remove standing water and protect nearby furniture and electrical equipment.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Pipe Repair',
          sentence: 'Install a suitable repair clamp or replace the damaged section with compatible fittings.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Pressure Verification',
          sentence: 'Restore supply gradually, check for leaks and verify stable water flow.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 44. Overhead Water Tank High-Pressure Disinfection
    'Overhead Water Tank High-Pressure Disinfection': ServiceSopData(
      serviceName: 'Overhead Water Tank High-Pressure Disinfection',
      equipment: [
        'Tank cleaning brush',
        'High-pressure cleaning machine',
        'Wet and dry vacuum or water extraction pump',
        'Approved tank disinfection solution',
        'Water testing kit',
        'Long-handled cleaning tools',
        'Protective gloves',
        'Safety goggles',
        'Respiratory protection as required',
        'Confined-space safety equipment where applicable',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Tank Inspection',
          sentence: 'Inspect tank condition, water quality, sediment and access arrangements.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Water Removal',
          sentence: 'Isolate the supply and drain the tank safely.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Mechanical Cleaning',
          sentence: 'Remove sediment, algae and deposits from accessible internal surfaces.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Disinfection',
          sentence: 'Apply an approved disinfection procedure at the specified concentration and contact time, then rinse where required.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Water Quality Verification',
          sentence: 'Refill, inspect for contamination and conduct appropriate water-quality checks.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 45. Tap, Spout & Flush Valve Leak Repair
    'Tap, Spout & Flush Valve Leak Repair': ServiceSopData(
      serviceName: 'Tap, Spout & Flush Valve Leak Repair',
      equipment: [
        'Adjustable spanner',
        'Basin wrench',
        'Pipe wrench',
        'Screwdriver set',
        'Cartridge removal tool',
        'Replacement washers and O-rings',
        'Compatible tap cartridges',
        'PTFE sealing tape',
        'Plumbing leak inspection tools',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Leak Inspection',
          sentence: 'Identify leakage from the tap, spout, joints or flush valve.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Water Isolation',
          sentence: 'Close the appropriate water supply and release pressure.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Component Dismantling',
          sentence: 'Remove the faulty cartridge, washer, seal or flush mechanism.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Repair & Replacement',
          sentence: 'Install compatible replacement components and reassemble the fixture.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Leak Testing',
          sentence: 'Restore water supply and verify flow, flushing and leak-free operation.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 46. Water Purifier RO + UV Complete Filter Replacement
    'Water Purifier RO + UV Complete Filter Replacement': ServiceSopData(
      serviceName: 'Water Purifier RO + UV Complete Filter Replacement',
      equipment: [
        'RO service toolkit',
        'Filter housing spanner',
        'Digital TDS meter',
        'Water pressure gauge',
        'Replacement sediment and carbon filters',
        'Compatible RO membrane',
        'UV lamp and compatible ballast where required',
        'Food-grade tubing and connectors',
        'Sanitisation solution suitable for drinking-water systems',
        'Leak inspection tools',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Water Quality Assessment',
          sentence: 'Check TDS, water flow, purifier condition and existing filter life.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'System Isolation',
          sentence: 'Turn off water and electrical supply and release stored pressure.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Filter Replacement',
          sentence: 'Replace filters and membrane according to the purifier model and maintenance requirements.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Sanitisation & Flushing',
          sentence: 'Clean the system using an approved method and flush replacement components as instructed.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Quality Testing',
          sentence: 'Verify leakage, water flow, TDS, UV operation and overall purifier performance.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),

    // 47. Western Commode EWC & Cistern Installation
    'Western Commode EWC & Cistern Installation': ServiceSopData(
      serviceName: 'Western Commode EWC & Cistern Installation',
      equipment: [
        'Adjustable spanner',
        'Pipe wrench',
        'Drill machine',
        'Measuring tape',
        'Digital spirit level',
        'Silicone sealant gun',
        'Toilet installation fittings',
        'Wax or compatible sealing ring',
        'Flexible inlet hose',
        'Compatible flush cistern fittings',
        'Protective gloves and safety footwear',
      ],
      steps: [
        SopStep(
          step: 1,
          title: 'Site Inspection',
          sentence: 'Check waste outlet position, water inlet, floor condition and toilet dimensions.',
          imageInfo: AppImages.step1,
        ),
        SopStep(
          step: 2,
          title: 'Old Fixture Removal',
          sentence: 'Isolate the water supply, drain the cistern and safely remove the existing toilet where applicable.',
          imageInfo: AppImages.step2,
        ),
        SopStep(
          step: 3,
          title: 'Commode Installation',
          sentence: 'Position and secure the new EWC with the correct outlet seal and fixing hardware.',
          imageInfo: AppImages.step3,
        ),
        SopStep(
          step: 4,
          title: 'Cistern & Plumbing Connection',
          sentence: 'Install the cistern, flush mechanism and water inlet connection.',
          imageInfo: AppImages.step4,
        ),
        SopStep(
          step: 5,
          title: 'Leak & Flush Testing',
          sentence: 'Test repeated flush cycles, water filling, drainage, stability and all plumbing connections.',
          imageInfo: AppImages.step5,
        ),
      ],
    ),
  };

  /// Fallback SOP for any unrecognized service
  static final ServiceSopData _defaultSop = ServiceSopData(
    serviceName: 'Standard Cooperative Service',
    equipment: ['Standard Artisan Toolkit', 'Safety PPE', 'Inspection Instruments'],
    steps: [
      SopStep(
        step: 1,
        title: 'Initial Diagnostic Inspection',
        sentence: 'Artisan inspects site conditions, power/water connections, and customer-reported symptoms.',
        imageInfo: AppImages.step1,
      ),
      SopStep(
        step: 2,
        title: 'Safety Isolation & Work Area Preparation',
        sentence: 'Isolate relevant supplies and set up protective floor mats and equipment before commencing work.',
        imageInfo: AppImages.step2,
      ),
      SopStep(
        step: 3,
        title: 'Component Servicing & Repair',
        sentence: 'Execute certified repair, overhaul or maintenance procedure in accordance with technical standards.',
        imageInfo: AppImages.step3,
      ),
      SopStep(
        step: 4,
        title: 'Rigorous Performance Testing',
        sentence: 'Verify operational safety, efficiency, and full functionality of all serviced parts.',
        imageInfo: AppImages.step4,
      ),
      SopStep(
        step: 5,
        title: 'Site Cleanup & Handover',
        sentence: 'Clean the work area thoroughly and collect completion verification upon customer satisfaction.',
        imageInfo: AppImages.step5,
      ),
    ],
  );

  static ServiceSopData getSopForService(String? serviceName) {
    if (serviceName == null || serviceName.trim().isEmpty) {
      return _defaultSop;
    }

    final trimmed = serviceName.trim();
    if (_catalog.containsKey(trimmed)) {
      return _catalog[trimmed]!;
    }

    // Case-insensitive / partial match
    final lower = trimmed.toLowerCase();
    for (final entry in _catalog.entries) {
      if (entry.key.toLowerCase() == lower ||
          lower.contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(lower)) {
        return entry.value;
      }
    }

    return _defaultSop;
  }
}
