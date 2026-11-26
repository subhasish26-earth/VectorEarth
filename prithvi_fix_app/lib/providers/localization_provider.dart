import 'package:flutter/foundation.dart';

enum AppLanguage {
  english('EN', 'English', 'English'),
  odia('OR', 'Odia', 'ଓଡ଼ିଆ'),
  hindi('HI', 'Hindi', 'हिन्दी');

  final String code;
  final String label;
  final String native;

  const AppLanguage(this.code, this.label, this.native);
}

class LocalizationProvider extends ChangeNotifier {
  static final LocalizationProvider instance = LocalizationProvider._();
  LocalizationProvider._();

  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;
  String get languageName => _currentLanguage.native;
  String get code => _currentLanguage.code;

  void setLanguage(AppLanguage lang) {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      notifyListeners();
    }
  }

  String tr(String key) {
    return _translations[_currentLanguage.code]?[key] ??
           _translations['EN']?[key] ??
           key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'EN': {
      // Navigation
      'nav_home': 'Home',
      'nav_services': 'Services',
      'nav_ai_fix': 'AI Fix',
      'nav_bookings': 'Bookings',
      'nav_account': 'Account',

      // Home Screen
      'app_title': 'Prithvi Fix',
      'gov_tag': 'PRITHVI FIX COOPERATIVE FEDERATION',
      'search_placeholder': 'Search 47 home services...',
      'categories': 'Categories',
      'view_all': 'View All',
      'most_booked': 'Most Booked Services',
      'emergency_squad': 'Emergency Squad (15-Min)',
      'fair_pricing_banner': 'Transparent 93-2-5 Cooperative Tariff: 93% directly to artisans, 5% to Artisan Social Security Fund, 2% platform upkeep.',

      // Categories
      'cat_plumbing': 'Plumbing',
      'cat_electrical': 'Electrical',
      'cat_appliance': 'Appliance Repair',
      'cat_carpentry': 'Carpentry',
      'cat_painting': 'Painting & Waterproofing',
      'cat_cleaning': 'Cleaning & Pest Control',
      'cat_gardening': 'Gardening & Landscaping',
      'cat_caregiving': 'Healthcare & Caregiving',
      'cat_driving': 'Driving & Chauffeur',

      // Common Buttons & Labels
      'btn_add': 'ADD',
      'btn_book_now': 'Book Now',
      'btn_track': 'Track Live ➔',
      'btn_cancel': 'Cancel',
      'btn_claim_warranty': 'Claim 30-Day Free Rework',
      'btn_download_invoice': 'Download PDF Invoice',
      'btn_close': 'Close',

      // Service Process & Spares
      'sop_heading': '5-Step Service Process',
      'step_of': 'Step',
      'equipment_heading': 'Required Cooperative Equipment',
      'locked_parts_heading': 'Locked Cooperative Parts Catalog',
      'locked_parts_sub': 'Prithvi Fix regulated rates. Artisans cannot overcharge for replacements.',
      'warranty_tag': 'Warranty',
      'workmanship_title': '30-Day Free Workmanship Warranty',
      'workmanship_desc': 'If any issue persists within 30 days of completion, a verified master artisan will re-visit at zero additional charge.',

      // Form IV & Billing
      'voucher_header': 'PRITHVI FIX OFFICIAL TAX INVOICE',
      'artisan_wage_label': '93% Direct Living Wage to Artisan:',
      'welfare_pool_label': '5% Mini-PF & ESIC Insurance Pool:',
      'platform_upkeep_label': '2% Cooperative Platform Upkeep:',
      'total_invoice_label': 'Total Invoice Amount:',
      'total_tariff_label': 'Total Regulated Tariff:',

      // Account Screen
      'profile_title': 'Profile & Preferences',
      'lang_setting': 'Language / ଭାଷା',
      'select_lang_title': 'Select Language / ଭାଷା ଚୟନ',
      'terms_service': 'Cooperative Terms of Service',
      'privacy_policy': 'Prithvi Fix Data Privacy & Rights',
      'help_support': 'Cooperative Helpline (1800-345-7788)',
      'sign_out': 'Sign Out',
    },

    'OR': {
      // Navigation
      'nav_home': 'ମୁଖ୍ୟ ପୃଷ୍ଠା',
      'nav_services': 'ସେବା ସମୂହ',
      'nav_ai_fix': 'AI ସହାୟକ',
      'nav_bookings': 'ଅର୍ଡର / ବୁକିଂ',
      'nav_account': 'ଖାତା / ପ୍ରୋଫାଇଲ୍',

      // Home Screen
      'app_title': 'ପୃଥ୍ୱୀ ଫିକ୍ସ',
      'gov_tag': 'ପୃଥ୍ୱୀ ଫିକ୍ସ ଶ୍ରମିକ ସମବାୟ ମହାସଂଘ',
      'search_placeholder': '୪୭ ଟି ଘରୋଇ ସେବା ଖୋଜନ୍ତୁ...',
      'categories': 'ବର୍ଗ ସମୂହ',
      'view_all': 'ସମସ୍ତ ଦେଖନ୍ତୁ',
      'most_booked': 'ସର୍ବାଧିକ ବୁକ୍ ହୋଇଥିବା ସେବା',
      'emergency_squad': 'ଜରୁରୀକାଳୀନ ସ୍କ୍ୱାଡ୍ (୧୫-ମିନିଟ୍)',
      'fair_pricing_banner': 'ନିୟନ୍ତ୍ରିତ ୯୩-୨-୫ ସମବାୟ ଶୁଳ୍କ: ୯୩% ସିଧାସଳଖ କାରିଗରଙ୍କୁ, ୫% ଶ୍ରମିକ ସୁରକ୍ଷା ପାଣ୍ଠିକୁ, ୨% ପ୍ଲାଟଫର୍ମ ରକ୍ଷଣାବେକ୍ଷଣ।',

      // Categories
      'cat_plumbing': 'ପ୍ଲମ୍ବିଂ (ଜଳ ସଂଯୋଗ)',
      'cat_electrical': 'ବିଦ୍ୟୁତ୍ କାର୍ଯ୍ୟ',
      'cat_appliance': 'ଉପକରଣ ମରାମତି',
      'cat_carpentry': 'କାଠ କାର୍ଯ୍ୟ (କାର୍ପେଣ୍ଟ୍ରି)',
      'cat_painting': 'ରଙ୍ଗ ଓ ୱାଟରପ୍ରୁଫିଂ',
      'cat_cleaning': 'ସଫେଇ ଓ କୀଟ ନିୟନ୍ତ୍ରଣ',
      'cat_gardening': 'ବଗିଚା କାର୍ଯ୍ୟ',
      'cat_caregiving': 'ସ୍ୱାସ୍ଥ୍ୟ ଓ ବରିଷ୍ଠ ଯତ୍ନ',
      'cat_driving': 'ଚାଳକ / ଡ୍ରାଇଭିଂ ସେବା',

      // Common Buttons & Labels
      'btn_add': 'ଯୋଡ଼ନ୍ତୁ',
      'btn_book_now': 'ବର୍ତ୍ତମାନ ବୁକ୍ କରନ୍ତୁ',
      'btn_track': 'ଲାଇଭ୍ ଟ୍ରାକ୍ କରନ୍ତୁ ➔',
      'btn_cancel': 'ବାତିଲ୍ କରନ୍ତୁ',
      'btn_claim_warranty': '୩୦-ଦିନର ମାଗଣା ୱାରେଣ୍ଟି ଦାବି କରନ୍ତୁ',
      'btn_download_invoice': 'ପିଡିଏଫ୍ ରସିଦ୍ ଡାଉନଲୋଡ୍ କରନ୍ତୁ',
      'btn_close': 'ବନ୍ଦ କରନ୍ତୁ',

      // Service Process & Spares
      'sop_heading': '୫-ପର୍ଯ୍ୟାୟ ସେବା ପଦ୍ଧତି',
      'step_of': 'ପର୍ଯ୍ୟାୟ',
      'equipment_heading': 'ଆବଶ୍ୟକୀୟ ସମବାୟ ଉପକରଣ',
      'locked_parts_heading': 'ନିୟନ୍ତ୍ରିତ ସମବାୟ ସ୍ପେୟାର୍ ପାର୍ଟ୍ସ କାଟାଲଗ୍',
      'locked_parts_sub': 'ପୃଥ୍ୱୀ ଫିକ୍ସ ନିୟନ୍ତ୍ରିତ ମୂଲ୍ୟ। କାରିଗର ଅଧିକ ଟଙ୍କା ନେଇପାରିବେ ନାହିଁ।',
      'warranty_tag': 'ୱାରେଣ୍ଟି',
      'workmanship_title': '୩୦-ଦିନ ମାଗଣା କାର୍ଯ୍ୟଦକ୍ଷତା ୱାରେଣ୍ଟି',
      'workmanship_desc': 'ସେବା ସରିବାର ୩୦ ଦିନ ମଧ୍ୟରେ କୌଣସି ଅସୁବିଧା ହେଲେ, ମାଷ୍ଟର କାରିଗର ବିନା ମୂଲ୍ୟରେ ପୁନର୍ବାର ସେବା ପ୍ରଦାନ କରିବେ।',

      // Form IV & Billing
      'voucher_header': 'ପୃଥ୍ୱୀ ଫିକ୍ସ ଅଫିସିଆଲ୍ ଟ୍ୟାକ୍ସ ଇନଭଏସ୍',
      'artisan_wage_label': '୯୩% ସିଧାସଳଖ କାରିଗରଙ୍କ ପାରିଶ୍ରମିକ:',
      'welfare_pool_label': '୫% ମିନି-ପିଏଫ୍ ଏବଂ ଇଏସଆଇ ପାଣ୍ଠି:',
      'platform_upkeep_label': '୨% ସମବାୟ ପ୍ଲାଟଫର୍ମ ରକ୍ଷଣାବେକ୍ଷଣ:',
      'total_invoice_label': 'ସମୁଦାୟ ଇନଭଏସ୍ ରାଶି:',
      'total_tariff_label': 'ସମୁଦାୟ ନିୟନ୍ତ୍ରିତ ଶୁଳ୍କ:',

      // Account Screen
      'profile_title': 'ପ୍ରୋଫାଇଲ୍ ଏବଂ ପସନ୍ଦ',
      'lang_setting': 'ଭାଷା / Language',
      'select_lang_title': 'ଭାଷା ଚୟନ କରନ୍ତୁ / Select Language',
      'terms_service': 'ସମବାୟ ସେବା ନିୟମାବଳୀ',
      'privacy_policy': 'ପୃଥ୍ୱୀ ଫିକ୍ସ ତଥ୍ୟ ଗୋପନୀୟତା ନୀତି',
      'help_support': 'ସମବାୟ ହେଲ୍ପଲାଇନ୍ (୧୮୦୦-୩୪୫-୭୭୮୮)',
      'sign_out': 'ଲଗ୍ ଆଉଟ୍ କରନ୍ତୁ',
    },

    'HI': {
      // Navigation
      'nav_home': 'होम',
      'nav_services': 'सेवाएं',
      'nav_ai_fix': 'AI फिक्स',
      'nav_bookings': 'बुकिंग्स',
      'nav_account': 'अकाउंट',

      // Home Screen
      'app_title': 'पृथ्वी फिक्स',
      'gov_tag': 'पृथ्वी फिक्स श्रम सहकारी महासंघ',
      'search_placeholder': '४७ घरेलू सेवाएं खोजें...',
      'categories': 'श्रेणियाँ',
      'view_all': 'सभी देखें',
      'most_booked': 'सर्वाधिक बुक की गई सेवाएं',
      'emergency_squad': 'आपातकालीन दस्ता (१५-मिनट)',
      'fair_pricing_banner': 'पारदर्शी ९३-२-५ सहकारी दर: ९३% सीधे कारीगर को, ५% कारीगर सामाजिक सुरक्षा कोष में, २% प्लेटफॉर्म रखरखाव।',

      // Categories
      'cat_plumbing': 'नलसाजी (प्लंबिंग)',
      'cat_electrical': 'बिजली कार्य (इलेक्ट्रिकल)',
      'cat_appliance': 'उपकरण मरम्मत',
      'cat_carpentry': 'बढ़ईगीरी (कारपेंट्री)',
      'cat_painting': 'पेंटिंग और वॉटरप्रूफिंग',
      'cat_cleaning': 'सफाई और कीट नियंत्रण',
      'cat_gardening': 'बागवानी और भूनिर्माण',
      'cat_caregiving': 'स्वास्थ्य और बुजुर्ग देखभाल',
      'cat_driving': 'ड्राइवर और शॉफर सेवाएं',

      // Common Buttons & Labels
      'btn_add': 'जोड़ें',
      'btn_book_now': 'अभी बुक करें',
      'btn_track': 'लाइव ट्रैक करें ➔',
      'btn_cancel': 'रद्द करें',
      'btn_claim_warranty': '३०-दिवसीय मुफ्त वारंटी दावा',
      'btn_download_invoice': 'पीडीएफ चालान डाउनलोड करें',
      'btn_close': 'बंद करें',

      // Service Process & Spares
      'sop_heading': '५-चरणीय सेवा प्रक्रिया',
      'step_of': 'चरण',
      'equipment_heading': 'आवश्यक सहकारी उपकरण',
      'locked_parts_heading': 'नियंत्रित सहकारी स्पेयर पार्ट्स सूची',
      'locked_parts_sub': 'पृथ्वी फिक्स नियंत्रित दरें। कारीगर अधिक शुल्क नहीं ले सकते।',
      'warranty_tag': 'वारंटी',
      'workmanship_title': '३०-दिवसीय निःशुल्क कार्यकुशलता वारंटी',
      'workmanship_desc': 'कार्य समाप्ति के ३० दिनों के भीतर किसी भी समस्या के समाधान हेतु मास्टर कारीगर बिना किसी अतिरिक्त शुल्क के पुनः सेवा देंगे।',

      // Form IV & Billing
      'voucher_header': 'पृथ्वी फिक्स आधिकारिक टैक्स चालान',
      'artisan_wage_label': '९३% प्रत्यक्ष कारीगर पारिश्रमिक:',
      'welfare_pool_label': '५% मिनी-पीएफ और ईएसआईसी कोष:',
      'platform_upkeep_label': '२% सहकारी प्लेटफॉर्म रखरखाव:',
      'total_invoice_label': 'कुल चालान राशि:',
      'total_tariff_label': 'कुल विनियमित शुल्क:',

      // Account Screen
      'profile_title': 'प्रोफाइल और प्राथमिकताएं',
      'lang_setting': 'भाषा / Language',
      'select_lang_title': 'भाषा चुनें / Select Language',
      'terms_service': 'सहकारी सेवा शर्तें',
      'privacy_policy': 'पृथ्वी फिक्स डेटा गोपनीयता नीति',
      'help_support': 'सहकारी हेल्पलाइन (१८००-३४५-७७८८)',
      'sign_out': 'साइन आउट',
    },
  };
}
