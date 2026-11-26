/// Centralized Asset Bridge for Prithvi Fix App
/// Maps all 81 tracked image assets from the Master Checklist.
/// Automatically falls back to curated high-resolution home-service photography
/// until custom photos are dropped into the assets/ folders.
class ImageAssetInfo {
  final String localPath;
  final String fallbackUrl;
  final bool hasLocalFile;

  const ImageAssetInfo({
    required this.localPath,
    required this.fallbackUrl,
    this.hasLocalFile = false,
  });
}

class AppImages {
  // ----------------------------------------------------
  // 1. BRANDING & ICONS
  // ----------------------------------------------------
  static const logoFull = ImageAssetInfo(
    localPath: 'assets/branding/logo_full.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800&q=80',
    hasLocalFile: true,
  );

  static const logoEmblem = ImageAssetInfo(
    localPath: 'assets/branding/logo_emblem.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400&q=80',
    hasLocalFile: true,
  );

  // ----------------------------------------------------
  // 2. ONBOARDING SLIDES
  // ----------------------------------------------------
  static const onboarding1 = ImageAssetInfo(
    localPath: 'assets/onboarding/onboarding_slide_1.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=1080&q=85',
  );

  static const onboarding2 = ImageAssetInfo(
    localPath: 'assets/onboarding/onboarding_slide_2.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=1080&q=85',
  );

  static const onboarding3 = ImageAssetInfo(
    localPath: 'assets/onboarding/onboarding_slide_3.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=1080&q=85',
  );

  // ----------------------------------------------------
  // 3. HERO PROMOTIONAL BANNERS
  // ----------------------------------------------------
  static const bannerAcFest = ImageAssetInfo(
    localPath: 'assets/banners/banner_ac_fest.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=1080&q=80',
  );

  static const bannerElectricalSafety = ImageAssetInfo(
    localPath: 'assets/banners/banner_electrical_safety.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=1080&q=80',
  );

  static const bannerEmergencySquad = ImageAssetInfo(
    localPath: 'assets/banners/banner_emergency_squad.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=1080&q=80',
  );

  static const bannerMonsoonWaterproof = ImageAssetInfo(
    localPath: 'assets/banners/banner_monsoon_waterproof.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=1080&q=80',
  );

  // ----------------------------------------------------
  // 4. 9 CATEGORY TILES (3D Studio Style)
  // ----------------------------------------------------
  static const catAcAppliance = ImageAssetInfo(
    localPath: 'assets/categories/cat_ac_appliance.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=500&q=80',
  );

  static const catElectrician = ImageAssetInfo(
    localPath: 'assets/categories/cat_electrician.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=500&q=80',
  );

  static const catPlumbing = ImageAssetInfo(
    localPath: 'assets/categories/cat_plumbing.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=500&q=80',
  );

  static const catCarpentry = ImageAssetInfo(
    localPath: 'assets/categories/cat_carpentry.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?w=500&q=80',
  );

  static const catPainting = ImageAssetInfo(
    localPath: 'assets/categories/cat_painting.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=500&q=80',
  );

  static const catCleaning = ImageAssetInfo(
    localPath: 'assets/categories/cat_cleaning.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500&q=80',
  );

  static const catGardening = ImageAssetInfo(
    localPath: 'assets/categories/cat_gardening.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1557429287-b2e26467fc2b?w=500&q=80',
  );

  static const catCaregiving = ImageAssetInfo(
    localPath: 'assets/categories/cat_caregiving.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?w=500&q=80',
  );

  static const catDriving = ImageAssetInfo(
    localPath: 'assets/categories/cat_driving.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=500&q=80',
  );

  // ----------------------------------------------------
  // 5. ALL 47 INDIVIDUAL SERVICES (Mapped by ID)
  // ----------------------------------------------------
  static final Map<int, ImageAssetInfo> services = {
    // 1-8: AC & Appliance
    1: const ImageAssetInfo(
      localPath: 'assets/services/service_ac_jet_clean.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&q=80',
      hasLocalFile: true,
    ),
    2: const ImageAssetInfo(
      localPath: 'assets/services/service_ac_install.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
    ),
    3: const ImageAssetInfo(
      localPath: 'assets/services/service_ac_gas_refill.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1607400201889-565b1dd75f8e?w=600&q=80',
    ),
    4: const ImageAssetInfo(
      localPath: 'assets/services/service_ac_pcb_repair.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1517420704952-d9f39e95b43e?w=600&q=80',
    ),
    5: const ImageAssetInfo(
      localPath: 'assets/services/service_fridge_repair.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=600&q=80',
    ),
    6: const ImageAssetInfo(
      localPath: 'assets/services/service_washing_machine.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=600&q=80',
    ),
    7: const ImageAssetInfo(
      localPath: 'assets/services/service_chimney_degrease.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
    ),
    8: const ImageAssetInfo(
      localPath: 'assets/services/service_microwave_repair.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=600&q=80',
    ),

    // 9-17: Electrical
    9: const ImageAssetInfo(
      localPath: 'assets/services/service_switch_socket.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600&q=80',
    ),
    10: const ImageAssetInfo(
      localPath: 'assets/services/service_ceiling_fan.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1505798577917-a65157d3320a?w=600&q=80',
    ),
    11: const ImageAssetInfo(
      localPath: 'assets/services/service_mcb_board.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&q=80',
    ),
    12: const ImageAssetInfo(
      localPath: 'assets/services/service_inverter_setup.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=600&q=80',
    ),
    13: const ImageAssetInfo(
      localPath: 'assets/services/service_house_rewiring.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=600&q=80',
    ),
    14: const ImageAssetInfo(
      localPath: 'assets/services/service_chandelier_install.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=600&q=80',
    ),
    15: const ImageAssetInfo(
      localPath: 'assets/services/service_ev_charger.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=600&q=80',
    ),
    16: const ImageAssetInfo(
      localPath: 'assets/services/service_geyser_repair.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1585338107529-13afc5f02586?w=600&q=80',
    ),
    17: const ImageAssetInfo(
      localPath: 'assets/services/service_short_circuit.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=600&q=80',
    ),

    // 18-25: Plumbing
    18: const ImageAssetInfo(
      localPath: 'assets/services/service_tap_repair.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),
    19: const ImageAssetInfo(
      localPath: 'assets/services/service_commode_install.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),
    20: const ImageAssetInfo(
      localPath: 'assets/services/service_water_tank_clean.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&q=80',
    ),
    21: const ImageAssetInfo(
      localPath: 'assets/services/service_booster_pump.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
    ),
    22: const ImageAssetInfo(
      localPath: 'assets/services/service_diverter_overhaul.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),
    23: const ImageAssetInfo(
      localPath: 'assets/services/service_drain_declog.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600&q=80',
    ),
    24: const ImageAssetInfo(
      localPath: 'assets/services/service_water_purifier.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=600&q=80',
    ),
    25: const ImageAssetInfo(
      localPath: 'assets/services/service_pipe_burst.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),

    // 26-31: Carpentry
    26: const ImageAssetInfo(
      localPath: 'assets/services/service_furniture_assembly.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?w=600&q=80',
    ),
    27: const ImageAssetInfo(
      localPath: 'assets/services/service_mortise_lock.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=80',
    ),
    28: const ImageAssetInfo(
      localPath: 'assets/services/service_kitchen_hinge.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
    ),
    29: const ImageAssetInfo(
      localPath: 'assets/services/service_door_planing.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986b88?w=600&q=80',
    ),
    30: const ImageAssetInfo(
      localPath: 'assets/services/service_window_roller.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1509644851169-2acc08aa25b5?w=600&q=80',
    ),
    31: const ImageAssetInfo(
      localPath: 'assets/services/service_wood_polish.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=600&q=80',
    ),

    // 32-36: Painting & Waterproofing
    32: const ImageAssetInfo(
      localPath: 'assets/services/service_interior_painting.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=600&q=80',
    ),
    33: const ImageAssetInfo(
      localPath: 'assets/services/service_terrace_waterproof.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&q=80',
    ),
    34: const ImageAssetInfo(
      localPath: 'assets/services/service_exterior_painting.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=600&q=80',
    ),
    35: const ImageAssetInfo(
      localPath: 'assets/services/service_wall_putty.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600&q=80',
    ),
    36: const ImageAssetInfo(
      localPath: 'assets/services/service_seepage_grouting.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),

    // 37-41: Cleaning & Pest Control
    37: const ImageAssetInfo(
      localPath: 'assets/services/service_apartment_clean.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&q=80',
    ),
    38: const ImageAssetInfo(
      localPath: 'assets/services/service_kitchen_degrease.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=600&q=80',
    ),
    39: const ImageAssetInfo(
      localPath: 'assets/services/service_bathroom_descaling.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=600&q=80',
    ),
    40: const ImageAssetInfo(
      localPath: 'assets/services/service_sofa_extraction.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&q=80',
    ),
    41: const ImageAssetInfo(
      localPath: 'assets/services/service_pest_control.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&q=80',
    ),

    // 42-43: Gardening
    42: const ImageAssetInfo(
      localPath: 'assets/services/service_lawn_mowing.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1557429287-b2e26467fc2b?w=600&q=80',
    ),
    43: const ImageAssetInfo(
      localPath: 'assets/services/service_drip_irrigation.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=600&q=80',
    ),

    // 44-45: Caregiving
    44: const ImageAssetInfo(
      localPath: 'assets/services/service_elderly_care.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?w=600&q=80',
    ),
    45: const ImageAssetInfo(
      localPath: 'assets/services/service_nursing_visit.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=600&q=80',
    ),

    // 46-47: Driving
    46: const ImageAssetInfo(
      localPath: 'assets/services/service_city_chauffeur.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&q=80',
    ),
    47: const ImageAssetInfo(
      localPath: 'assets/services/service_highway_chauffeur.jpg',
      fallbackUrl: 'https://images.unsplash.com/photo-1506015391300-4802dc74de2e?w=600&q=80',
    ),
  };

  // ----------------------------------------------------
  // 6. 5-STEP AC VISUAL PROCESS
  // ----------------------------------------------------
  static const step1 = ImageAssetInfo(
    localPath: 'assets/services/step1_preservice.jpg',
    fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&q=80',
    hasLocalFile: true,
  );

  static const step2 = ImageAssetInfo(
    localPath: 'assets/services/step2_indoor_clean.jpg',
    fallbackUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&q=80',
    hasLocalFile: true,
  );

  static const step3 = ImageAssetInfo(
    localPath: 'assets/services/step3_outdoor_clean.jpg',
    fallbackUrl: 'https://images.unsplash.com/photo-1607400201889-565b1dd75f8e?w=600&q=80',
    hasLocalFile: true,
  );

  static const step4 = ImageAssetInfo(
    localPath: 'assets/services/step4_gas_check.jpg',
    fallbackUrl: 'https://images.unsplash.com/photo-1517420704952-d9f39e95b43e?w=600&q=80',
    hasLocalFile: true,
  );

  static const step5 = ImageAssetInfo(
    localPath: 'assets/services/step5_cleanup.jpg',
    fallbackUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&q=80',
    hasLocalFile: true,
  );

  // ----------------------------------------------------
  // 7. TRUST & VALUE CARDS
  // ----------------------------------------------------
  static const trustVerifiedArtisan = ImageAssetInfo(
    localPath: 'assets/trust/trust_verified_artisan.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
  );

  static const trustFairWage = ImageAssetInfo(
    localPath: 'assets/trust/trust_fair_wage.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=800&q=80',
  );

  static const trustDualOtp = ImageAssetInfo(
    localPath: 'assets/trust/trust_dual_otp.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=800&q=80',
  );

  static const trust30DayWarranty = ImageAssetInfo(
    localPath: 'assets/trust/trust_30day_warranty.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1450133064473-71024230f91b?w=800&q=80',
  );

  // ----------------------------------------------------
  // 8. LIVE TRACKING & STATES
  // ----------------------------------------------------
  static const technicianAvatar = ImageAssetInfo(
    localPath: 'assets/tracking/technician_avatar_1.png',
    fallbackUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
    hasLocalFile: true,
  );
}
