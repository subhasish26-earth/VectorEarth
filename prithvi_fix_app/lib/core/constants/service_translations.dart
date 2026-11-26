import '../../providers/localization_provider.dart';

class ServiceNameTranslations {
  static final Map<String, String> _odia = {
    // Appliance Repair
    'Split AC Deep Jet Cleaning & Service': 'ସ୍ପ୍ଲିଟ୍ ଏସି ଡିପ୍ ଜେଟ୍ ସର୍ଭିସିଂ',
    'Split AC Installation (New/Relocation)': 'ସ୍ପ୍ଲିଟ୍ ଏସି ସ୍ଥାପନ (ନୂତନ / ସ୍ଥାନାନ୍ତର)',
    'AC Gas Leak Repair & Refilling': 'ଏସି ଗ୍ୟାସ୍ ଲିକ୍ ମରାମତି ଏବଂ ଗ୍ୟାସ୍ ଭର୍ତ୍ତି',
    'Inverter AC PCB Diagnostics & Repair': 'ଇନଭର୍ଟର ଏସି ପିସିବି ସର୍କିଟ୍ ମରାମତି',
    'Double-Door Refrigerator Cooling & Gas Charge': 'ଡବଲ୍-ଡୋର୍ ରେଫ୍ରିଜରେଟର କୁଲିଂ ଏବଂ ଗ୍ୟାସ୍ ଚାର୍ଜ',
    'Fully-Automatic Washing Machine Repair': 'ଫୁଲି-ଅଟୋମେଟିକ୍ ୱାଶିଂ ମେସିନ୍ ମରାମତି',
    'Kitchen Chimney & Hob Deep Degreasing': 'ରୋଷେଇ ଘର ଚିମନି ଓ ହବ୍ ଗଭୀର ସଫେଇ',
    'Microwave Oven Magnetron & Touchpad Service': 'ମାଇକ୍ରୋୱେଭ୍ ଓଭେନ୍ ମ୍ୟାଗ୍ନେଟ୍ରନ୍ ଓ ଟଚ୍ ସର୍ଭିସ୍',

    // Electrical
    'Switch, Socket & Modular Plate Replacement': 'ସ୍ୱିଚ୍, ସକେଟ୍ ଓ ମଡ୍ୟୁଲାର୍ ପ୍ଲେଟ୍ ବଦଳ',
    'Ceiling Fan Installation & Overhaul': 'ଫ୍ୟାନ୍ ଫିଟିଂ ଏବଂ ମରାମତି',
    'Main MCB & Distribution Board Replacement': 'ମେନ୍ ଏମସିବି (MCB) ଓ ଡିଷ୍ଟ୍ରିବ୍ୟୁସନ୍ ବୋର୍ଡ ସ୍ଥାପନ',
    'Inverter & Battery Home Wiring Setup': 'ଇନଭର୍ଟର ଓ ବ୍ୟାଟେରୀ ଘରୋଇ ୱାୟାରିଂ',
    'Complete House Concealed Rewiring': 'ସମ୍ପୂର୍ଣ୍ଣ ଘରର କନସିଲ୍ଡ ୱାୟାରିଂ',
    'Chandelier & Designer Pendant Light Fitting': 'ଝୁମର (Chandelier) ଓ ଡିଜାଇନର୍ ଲାଇଟ୍ ଫିଟିଂ',
    'EV Four-Wheeler Home Charger Line (7.4kW)': 'ଇଭି (EV) କାର୍ ଚାର୍ଜର ଲାଇନ୍ ସଂଯୋଗ',
    'Electric Geyser Fast Heating Diagnostic & Repair': 'ଇଲେକ୍ଟ୍ରିକ୍ ଗିଜର୍ ତ୍ରୁଟି ନିବାରଣ ଓ ମରାମତି',
    'Emergency Electrical Short Circuit Diagnostics': 'ଜରୁରୀକାଳୀନ ବିଦ୍ୟୁତ୍ ସର୍ଟ ସର୍କିଟ୍ ମରାମତି',

    // Plumbing
    'Tap, Spout & Flush Valve Leak Repair': 'ପାଣି ଟ୍ୟାପ୍, ସ୍ପାଉଟ୍ ଓ ଫ୍ଲସ୍ ଭାଲ୍ଭ ଲିକ୍ ମରାମତି',
    'Western Commode EWC & Cistern Installation': 'ୱେଷ୍ଟର୍ଣ୍ଣ କମୋଡ୍ (EWC) ଓ ସିଷ୍ଟର୍ଣ୍ଣ ସ୍ଥାପନ',
    'Overhead Water Tank High-Pressure Disinfection': 'ପାଣି ଟାଙ୍କି ଉଚ୍ଚ-ଚାପ ଜୀବାଣୁନାଶକ ସଫେଇ',
    'Automatic Water Booster Pump Installation': 'ସ୍ୱୟଂଚାଳିତ ୱାଟର ବୁଷ୍ଟର ପମ୍ପ ସ୍ଥାପନ',
    'Bathroom Multi-Flow Concealed Diverter Overhaul': 'ବାଥରୁମ୍ ମଲ୍ଟି-ଫ୍ଲୋ କନସିଲ୍ଡ ଡାଇଭର୍ଟର ମରାମତି',
    'Blocked Drain & Sewer Pipe De-clogging': 'ଜାମ୍ ଡ୍ରେନ୍ ଓ ସିୱେରେଜ୍ ପାଇପ୍ ସଫେଇ',
    'Water Purifier RO + UV Complete Filter Replacement': 'ୱାଟର ଫିଲ୍ଟର RO + UV ସମ୍ପୂର୍ଣ୍ଣ ଫିଲ୍ଟର ବଦଳ',
    'Emergency 60-Min Main Pipe Burst Containment': 'ଜରୁରୀକାଳୀନ ମୁଖ୍ୟ ପାଇପ୍ ଫାଟିବା ମରାମତି (୬୦ ମିନିଟ୍)',

    // Carpentry
    'Flatpack Furniture Assembly (Bed, Wardrobe, Desk)': 'ଆସବାବପତ୍ର ଖଞ୍ଜିବା (ଖଟ, ଆଲମିରା, ଟେବୁଲ୍)',
    'High-Security Main Door Mortise Lock Fitting': 'ମୁଖ୍ୟ କବାଟ ମର୍ଟିସ୍ ଲକ୍ ସ୍ଥାପନ',
    'Modular Kitchen Soft-Close Hydraulic Hinge Upgrade': 'ମଡ୍ୟୁଲାର୍ କିଚେନ୍ ସଫ୍ଟ-କ୍ଲୋଜ୍ ହାଇଡ୍ରୋଲିକ୍ ହିଞ୍ଜ୍',
    'Wooden Door Planing, Trimming & Floor Clearance': 'କାଠ କବାଟ କଟିଂ ଓ ଚଟାଣ କ୍ଲିୟରାନ୍ସ',
    'Aluminium Sliding Window Roller & Track Overhaul': 'ଆଲୁମିନିୟମ୍ ସ୍ଲାଇଡିଂ ଝରକା ରୋଲର୍ ଓ ଟ୍ରାକ୍ ମରାମତି',
    'Premium French Spirit & Wood PU Clear Polish': 'ପ୍ରିମିୟମ୍ କାଠ ପଲିସ୍ (ଫ୍ରେଞ୍ଚ୍ ସ୍ପିରିଟ୍ ଓ PU)',

    // Painting
    'Interior Luxury Silk Emulsion Painting': 'ଘର ଭିତର ସିଲ୍କ ଇମଲସନ୍ ରଙ୍ଗ କାର୍ଯ୍ୟ',
    'Terrace Chemical Elastomeric Waterproofing': 'ଛାତ ରାସାୟନିକ ୱାଟରପ୍ରୁଫିଂ କାର୍ଯ୍ୟ',
    'Exterior Anti-Fungal Weathercoat Painting': 'ଘର ବାହାର ଆଣ୍ଟି-ଫଙ୍ଗାଲ୍ ୱେଦରକୋଟ୍ ରଙ୍ଗ',
    'Wall Putty Application & Machine Sanding': 'କାନ୍ଥ ପୁଟି ଲେପନ ଓ ମେସିନ୍ ସ୍ୟାଣ୍ଡିଂ',
    'Seepage Damp Treatment with Injection Grouting': 'କାନ୍ଥ ସିପେଜ୍ ଓ ଓଦା ଭଙ୍ଗା ଇଞ୍ଜେକ୍ସନ ଗ୍ରାଉଟିଂ',

    // Cleaning
    'Full Apartment Deep Machine Cleaning': 'ସମ୍ପୂର୍ଣ୍ଣ ଘରର ମେସିନ୍ ଦ୍ୱାରା ଗଭୀର ସଫେଇ',
    'Intensive Kitchen Oil & Grease Descaling': 'ରୋଷେଇ ଘର ତେଲ ଓ ମଳି ଗଭୀର ସଫେଇ',
    'Bathroom Acid Free Descaling & Grout Restoration': 'ବାଥରୁମ୍ ଏସିଡ୍-ମୁକ୍ତ ସଫେଇ ଓ ଟାଇଲ୍ସ ଗ୍ରାଉଟିଂ',
    'Sofa & Mattress Foam Shampoo & Extraction Wash': 'ସୋଫା ଓ ଗଦି ଫୋମ୍ ସାମ୍ପୁ ସଫେଇ',
    'Odorless Herbal Gel Cockroach & Pest Barrier': 'ଗନ୍ଧହୀନ ହର୍ବାଲ୍ ଜେଲ୍ କୀଟ ଓ ଅସରପା ନିୟନ୍ତ୍ରଣ',

    // Gardening
    'Lawn Mowing & Landscape Shrub Pruning': 'ଘାସ କଟା ଏବଂ ବଗିଚା ଗଛ କଟିଂ / ଛଟେଇ',
    'Terrace Garden Micro Drip Automation Setup': 'ଛାତ ବଗିଚା ସ୍ୱୟଂଚାଳିତ ଡ୍ରିପ୍ ଜଳସେଚନ',

    // Caregiving
    'Elderly Bedside Attendant (Daily Day Care)': 'ବରିଷ୍ଠ ନାଗରିକ ଦିବା ଯତ୍ନ ସହାୟକ',
    'Post-Operative Dressing & Injection Nursing Visit': 'ଅସ୍ତ୍ରୋପଚାର ପରବର୍ତ୍ତୀ ଡ୍ରେସିଂ ଓ ଇଞ୍ଜେକ୍ସନ୍ ନର୍ସିଂ',

    // Driving
    'Professional City Chauffeur (8-Hour Shift)': 'ପେସାଦାର ସହର ଚାଳକ (୮-ଘଣ୍ଟା ଶିଫ୍ଟ)',
    'Outstation Long-Distance Highway Chauffeur': 'ଦୂରଗାମୀ ରାଜପଥ ଚାଳକ (ଆଉଟଷ୍ଟେସନ୍)',
  };

  static final Map<String, String> _hindi = {
    // Appliance Repair
    'Split AC Deep Jet Cleaning & Service': 'स्प्लिट एसी डीप जेट सर्विसिंग',
    'Split AC Installation (New/Relocation)': 'स्प्लिट एसी स्थापना (नया / स्थानांतरण)',
    'AC Gas Leak Repair & Refilling': 'एसी गैस रिसाव मरम्मत और रीफिलिंग',
    'Inverter AC PCB Diagnostics & Repair': 'इन्वर्टर एसी पीसीबी सर्किट मरम्मत',
    'Double-Door Refrigerator Cooling & Gas Charge': 'डबल-डोर रेफ्रिजरेटर कूलिंग और गैस चार्ज',
    'Fully-Automatic Washing Machine Repair': 'पूरी तरह से स्वचालित वाशिंग मशीन मरम्मत',
    'Kitchen Chimney & Hob Deep Degreasing': 'रसोई चिमनी और हॉब गहरी सफाई',
    'Microwave Oven Magnetron & Touchpad Service': 'माइक्रोवेव ओवन मैग्नेट्रॉन और टचपैड सेवा',

    // Electrical
    'Switch, Socket & Modular Plate Replacement': 'स्विच, सॉकेट और मॉड्यूलर प्लेट प्रतिस्थापन',
    'Ceiling Fan Installation & Overhaul': 'सीलिंग फैन इंस्टॉलेशन और मरम्मत',
    'Main MCB & Distribution Board Replacement': 'मुख्य एमसीबी और वितरण बोर्ड प्रतिस्थापन',
    'Inverter & Battery Home Wiring Setup': 'इन्वर्टर और बैटरी घरेलू वायरिंग सेटअप',
    'Complete House Concealed Rewiring': 'पूरे घर की कंसील्ड वायरिंग',
    'Chandelier & Designer Pendant Light Fitting': 'झूमर और डिजाइनर पेंडेंट लाइट फिटिंग',
    'EV Four-Wheeler Home Charger Line (7.4kW)': 'ईवी फोर-व्हीलर होम चार्जर लाइन कनेक्शन',
    'Electric Geyser Fast Heating Diagnostic & Repair': 'इलेक्ट्रिक गीजर हीटिंग मरम्मत',
    'Emergency Electrical Short Circuit Diagnostics': 'आपातकालीन शॉर्ट सर्किट जांच व मरम्मत',

    // Plumbing
    'Tap, Spout & Flush Valve Leak Repair': 'नल, स्पाउट और फ्लश वाल्व लीकेज मरम्मत',
    'Western Commode EWC & Cistern Installation': 'वेस्टर्न कमोड (EWC) और सिस्टर्न स्थापना',
    'Overhead Water Tank High-Pressure Disinfection': 'पानी की टंकी उच्च दबाव कीटाणुशोधन',
    'Automatic Water Booster Pump Installation': 'स्वचालित वाटर बूस्टर पंप स्थापना',
    'Bathroom Multi-Flow Concealed Diverter Overhaul': 'बाथरूम मल्टी-फ्लो कंसील्ड डायवर्टर मरम्मत',
    'Blocked Drain & Sewer Pipe De-clogging': 'जाम नाली और सीवर पाइप की सफाई',
    'Water Purifier RO + UV Complete Filter Replacement': 'वाटर प्यूरीफायर RO + UV फिल्टर प्रतिस्थापन',
    'Emergency 60-Min Main Pipe Burst Containment': 'आपातकालीन मुख्य पाइप फटने की मरम्मत (६० मिनट)',

    // Carpentry
    'Flatpack Furniture Assembly (Bed, Wardrobe, Desk)': 'फर्नीचर असेंबली (बेड, अलमारी, मेज)',
    'High-Security Main Door Mortise Lock Fitting': 'मुख्य दरवाजा मोर्टिज़ लॉक फिटिंग',
    'Modular Kitchen Soft-Close Hydraulic Hinge Upgrade': 'मॉड्यूलर किचन सॉफ्ट-क्लोज़ हाइड्रोलिक हिंज',
    'Wooden Door Planing, Trimming & Floor Clearance': 'लकड़ी के दरवाजे की ट्रिमिंग और समतलीकरण',
    'Aluminium Sliding Window Roller & Track Overhaul': 'एल्युमीनियम स्लाइडिंग खिड़की रोलर और ट्रैक मरम्मत',
    'Premium French Spirit & Wood PU Clear Polish': 'प्रीमियम वुड पॉलिश (फ्रेंच स्पिरिट और पीयू)',

    // Painting
    'Interior Luxury Silk Emulsion Painting': 'आंतरिक लक्जरी सिल्क इमल्शन पेंटिंग',
    'Terrace Chemical Elastomeric Waterproofing': 'छत केमिकल इलास्टोमेरिक वॉटरप्रूफिंग',
    'Exterior Anti-Fungal Weathercoat Painting': 'बाहरी एंटी-फंगल वेदरकोट पेंटिंग',
    'Wall Putty Application & Machine Sanding': 'वॉल पुट्टी लगाना और मशीन सैंडिंग',
    'Seepage Damp Treatment with Injection Grouting': 'दीवार सीलन उपचार (इंजेक्शन ग्राउटिंग)',

    // Cleaning
    'Full Apartment Deep Machine Cleaning': 'पूरे अपार्टमेंट की मशीन से गहरी सफाई',
    'Intensive Kitchen Oil & Grease Descaling': 'रसोई तेल और ग्रीस की गहन सफाई',
    'Bathroom Acid Free Descaling & Grout Restoration': 'बाथरूम एसिड-मुक्त सफाई और ग्राउटिंग',
    'Sofa & Mattress Foam Shampoo & Extraction Wash': 'सोफा और गद्दे की फोम शैम्पू धुलाई',
    'Odorless Herbal Gel Cockroach & Pest Barrier': 'गंधहीन हर्बल जेल कॉकरोच और कीट नियंत्रण',

    // Gardening
    'Lawn Mowing & Landscape Shrub Pruning': 'लॉन घास कटाई और झाड़ियों की छंटाई',
    'Terrace Garden Micro Drip Automation Setup': 'टेरेस गार्डन ऑटोमैटिक ड्रिप सिंचाई',

    // Caregiving
    'Elderly Bedside Attendant (Daily Day Care)': 'बुजुर्गों की देखभाल हेतु अटेंडेंट (दैनिक)',
    'Post-Operative Dressing & Injection Nursing Visit': 'ऑपरेशन उपरांत ड्रेसिंग व इंजेक्शन नर्सिंग',

    // Driving
    'Professional City Chauffeur (8-Hour Shift)': 'पेशेवर सिटी ड्राइवर (८-घंटे की शिफ्ट)',
    'Outstation Long-Distance Highway Chauffeur': 'लंबी दूरी के लिए हाईवे ड्राइवर (आउटस्टेशन)',
  };

  /// Translate service name according to active language
  static String translate(String originalName) {
    final lang = LocalizationProvider.instance.currentLanguage;
    if (lang == AppLanguage.odia) {
      return _odia[originalName] ?? originalName;
    } else if (lang == AppLanguage.hindi) {
      return _hindi[originalName] ?? originalName;
    }
    return originalName;
  }
}
