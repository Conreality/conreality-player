/* This is free and unencumbered software released into the public domain. */

import 'dart:ui' show Locale;

abstract class GeneratedStrings {
  final Locale currentLocale;
  final Locale defaultLocale;

  GeneratedStrings(this.currentLocale, this.defaultLocale);

  String get(final String id) =>
    _data[id][currentLocale.languageCode] ?? _data[id][defaultLocale.languageCode];

  static const supportedLocales = <Locale>[
  // BEGIN LOCALES
    // Default language:
    Locale('en'), // English
    // Other languages:
    Locale('cs'), // Czech
    Locale('de'), // German
    Locale('es'), // Spanish
    Locale('fi'), // Finnish
    Locale('fr'), // French
    Locale('ja'), // Japanese
    Locale('pl'), // Polish
    Locale('pt'), // Portuguese
    Locale('ro'), // Romanian
    Locale('ru'), // Russian
    Locale('sk'), // Slovak
    Locale('sv'), // Swedish
    Locale('uk'), // Ukrainian
    Locale('zh'), // Chinese
  // END LOCALES
  ];

  // BEGIN GETTERS
  String get appTitle => get('appTitle');
  String get appVersion => get('appVersion');
  String get austria => get('austria');
  String get belgium => get('belgium');
  String get camera => get('camera');
  String get cancel => get('cancel');
  String get chat => get('chat');
  String get china => get('china');
  String get chinese => get('chinese');
  String get compass => get('compass');
  String get connect => get('connect');
  String get connectToGame => get('connectToGame');
  String get connectToWiFiToJoin => get('connectToWiFiToJoin');
  String get connecting => get('connecting');
  String get continue_ => get('continue_');
  String get country => get('country');
  String get czech => get('czech');
  String get czechia => get('czechia');
  String get drone => get('drone');
  String get dutch => get('dutch');
  String get england => get('england');
  String get english => get('english');
  String get enterGameURL => get('enterGameURL');
  String get estonia => get('estonia');
  String get estonian => get('estonian');
  String get exit => get('exit');
  String get exitGame => get('exitGame');
  String get feedbackURL => get('feedbackURL');
  String get finland => get('finland');
  String get finnish => get('finnish');
  String get france => get('france');
  String get french => get('french');
  String get german => get('german');
  String get germany => get('germany');
  String get home => get('home');
  String get ireland => get('ireland');
  String get irish => get('irish');
  String get japan => get('japan');
  String get japanese => get('japanese');
  String get latvia => get('latvia');
  String get latvian => get('latvian');
  String get legalese => get('legalese');
  String get lithuania => get('lithuania');
  String get lithuanian => get('lithuanian');
  String get loading => get('loading');
  String get local => get('local');
  String get localGame => get('localGame');
  String get maneuver => get('maneuver');
  String get map => get('map');
  String get netherlands => get('netherlands');
  String get norway => get('norway');
  String get norwegian => get('norwegian');
  String get notImplemented => get('notImplemented');
  String get objective => get('objective');
  String get pistol => get('pistol');
  String get player => get('player');
  String get poland => get('poland');
  String get polish => get('polish');
  String get portugal => get('portugal');
  String get portuguese => get('portuguese');
  String get reload => get('reload');
  String get remoteGame => get('remoteGame');
  String get retry => get('retry');
  String get rifle => get('rifle');
  String get romania => get('romania');
  String get romanian => get('romanian');
  String get russia => get('russia');
  String get russian => get('russian');
  String get saved => get('saved');
  String get scan => get('scan');
  String get scanThisWithAnotherDevice => get('scanThisWithAnotherDevice');
  String get scotland => get('scotland');
  String get send => get('send');
  String get sendFeedback => get('sendFeedback');
  String get sendMessage => get('sendMessage');
  String get settings => get('settings');
  String get share => get('share');
  String get slovak => get('slovak');
  String get slovakia => get('slovakia');
  String get spain => get('spain');
  String get spanish => get('spanish');
  String get sweden => get('sweden');
  String get swedish => get('swedish');
  String get switzerland => get('switzerland');
  String get team => get('team');
  String get turret => get('turret');
  String get ukraine => get('ukraine');
  String get ukrainian => get('ukrainian');
  // END GETTERS

  static Map<String, Map<String, String>> _data = {
  // BEGIN STRINGS
    'appTitle': {
      'en': "Conreality Player",
    },
    'appVersion': {
      'cs': "Říjen 2018",
      'de': "Oktober 2018",
      'en': "January 2019",
      'es': "Octubre de 2018",
      'fi': "Lokakuu 2018",
      'fr': "Octobre 2018",
      'ja': "2018年10月",
      'pl': "Październik 2018",
      'pt': "Outubro de 2018",
      'ro': "Octombrie 2018",
      'ru': "Октябрь 2018 г.",
      'sk': "Október 2018",
      'sv': "Oktober 2018",
      'uk': "Жовтень 2018 р",
      'zh': "2018年10月",
    },
    'austria': {
      'en': "Austria",
    },
    'belgium': {
      'en': "Belgium",
    },
    'camera': {
      'en': "Camera",
      'fi': "Kamera",
    },
    'cancel': {
      'en': "Cancel",
      'fi': "Peruuta",
      'sk': "Zrušiť",
    },
    'chat': {
      'en': "Chat",
      'fi': "Juttelu",
      'sk': "Rozhovor",
      'sv': "Chatt",
    },
    'china': {
      'en': "China",
      'fi': "Kiina",
    },
    'chinese': {
      'en': "Chinese",
      'fi': "kiina",
    },
    'compass': {
      'en': "Compass",
      'fi': "Kompassi",
      'sk': "Kompas",
      'sv': "Kompass",
    },
    'connect': {
      'en': "Connect",
      'fi': "Yhdistä",
      'sk': "Pripojiť",
      'sv': "Anslut",
    },
    'connectToGame': {
      'en': "Connect to a game...",
      'fi': "Yhdistä peliin...",
      'sk': "Pripojiť ku hre...",
      'sv': "Anslut till ett spel...",
    },
    'connectToWiFiToJoin': {
      'en': "Connect to a Wi-Fi network to join a game.",
      'fi': "Liity Wi-Fi -verkkoon yhdistääksesi peliin.",
      'sk': "Pripojiť ku WiFi sieti a pridať do hry.",
    },
    'connecting': {
      'en': "Connecting...",
      'fi': "Yhdistetään...",
      'sk': "Pripájam...",
      'sv': "Ansluter...",
    },
    'continue_': {
      'en': "Continue",
      'fi': "Jatka",
    },
    'country': {
      'en': "Country",
      'fi': "Maa",
    },
    'czech': {
      'en': "Czech",
      'fi': "tšekki",
    },
    'czechia': {
      'en': "Czechia",
      'fi': "Tšekki",
    },
    'drone': {
      'en': "Drone",
      'fi': "drooni",
    },
    'dutch': {
      'en': "Dutch",
      'fi': "hollanti",
    },
    'england': {
      'en': "United Kingdom",
      'fi': "Englanti",
    },
    'english': {
      'cs': "anglický",
      'de': "Englische",
      'en': "English",
      'es': "inglés",
      'fi': "englanti",
      'fr': "Anglaise",
      'ja': "英語",
      'pl': "angielski",
      'pt': "Inglesa",
      'ro': "engleza",
      'ru': "английский",
      'sk': "anglický",
      'sv': "engelska",
      'uk': "англійська",
      'zh': "英语",
    },
    'enterGameURL': {
      'en': "Enter the game URL:",
      'fi': "Anna pelin URL-osoite:",
      'sk': "Zadaj URL adresu hry:",
    },
    'estonia': {
      'en': "Estonia",
    },
    'estonian': {
      'en': "Estonian",
    },
    'exit': {
      'en': "Exit",
      'fi': "Poistu",
      'sk': "Ukončiť",
      'sv': "Avsluta",
    },
    'exitGame': {
      'en': "Exit this game",
      'fi': "Poistu tästä pelistä",
      'sk': "Ukončiť hru",
      'sv': "Avsluta spelet",
    },
    'feedbackURL': {
      'en': "https://github.com/conreality/conreality-player/issues/new",
    },
    'finland': {
      'cs': "Finsko",
      'de': "Finnland",
      'en': "Finland",
      'es': "Finlandia",
      'fi': "Suomi",
      'fr': "Finlande",
      'ja': "フィンランド",
      'pl': "Finlandia",
      'pt': "Finlândia",
      'ro': "Finlanda",
      'ru': "Финляндия",
      'sk': "Fínsko",
      'uk': "Фінляндія",
      'zh': "芬兰",
    },
    'finnish': {
      'en': "Finnish",
      'fi': "suomi",
      'ru': "Финский",
      'sv': "finska",
      'uk': "Фінська",
    },
    'france': {
      'en': "France",
      'fi': "Ranska",
    },
    'french': {
      'en': "French",
      'fi': "ranska",
    },
    'german': {
      'en': "German",
      'fi': "saksa",
    },
    'germany': {
      'en': "Germany",
      'fi': "Saksa",
    },
    'home': {
      'en': "Home",
      'fi': "Koti",
      'sk': "Domov",
      'sv': "Hem",
    },
    'ireland': {
      'en': "Ireland",
    },
    'irish': {
      'en': "Irish",
    },
    'japan': {
      'en': "Japan",
      'fi': "Japani",
    },
    'japanese': {
      'en': "Japanese",
      'fi': "japani",
    },
    'latvia': {
      'en': "Latvia",
    },
    'latvian': {
      'en': "Latvian",
    },
    'legalese': {
      'en': "This is free and unencumbered software released into the public domain.",
      'fi': "Tämä on tekijänoikeudeton julkisohjelma, käytettäväksi vapaasti ja rajoituksetta.",
      'sk': "Tento program je voľne šíriteľný a nezaťažený licenčnými podmienkami.",
    },
    'lithuania': {
      'en': "Lithuania",
    },
    'lithuanian': {
      'en': "Lithuanian",
    },
    'loading': {
      'en': "Loading...",
      'fi': "Ladataan...",
      'sk': "Načítavam...",
      'sv': "Laddar...",
    },
    'local': {
      'en': "Local",
      'fi': "Paikalliset",
      'sk': "Lokálne",
      'sv': "Lokalt spel",
    },
    'localGame': {
      'en': "Local game",
      'fi': "Lähipeli",
      'sk': "Lokálna hra",
      'sv': "Lokalt",
    },
    'maneuver': {
      'en': "Maneuver",
      'fi': "Manööveri",
    },
    'map': {
      'cs': "Mapa",
      'en': "Map",
      'fi': "Kartta",
      'sk': "Mapa",
      'sv': "Karta",
    },
    'netherlands': {
      'en': "Netherlands",
    },
    'norway': {
      'en': "Norway",
      'fi': "Norja",
    },
    'norwegian': {
      'en': "Norwegian",
      'fi': "norja",
    },
    'notImplemented': {
      'en': "Not implemented yet.",
      'fi': "Ei vielä toteutettu.",
      'sv': "Inte genomförd än.",
    },
    'objective': {
      'en': "Objective",
      'fi': "Päämäärä",
    },
    'pistol': {
      'en': "Pistol",
      'fi': "Pistooli",
    },
    'player': {
      'cs': "Hráč",
      'en': "Player",
      'fi': "Pelaaja",
      'sk': "Hráč",
      'sv': "Spelare",
    },
    'poland': {
      'en': "Poland",
      'fi': "Puola",
    },
    'polish': {
      'en': "Polish",
      'fi': "puola",
    },
    'portugal': {
      'en': "Portugal",
      'fi': "Portugali",
    },
    'portuguese': {
      'en': "Portuguese",
      'fi': "portugali",
    },
    'reload': {
      'en': "Reload",
    },
    'remoteGame': {
      'en': "Remote game",
      'fi': "Etäpeli",
      'sk': "Vzdialená hra",
      'sv': "Fjärrspel",
    },
    'retry': {
      'en': "Retry",
      'fi': "Uudestaan",
      'sk': "Skúsiť znova",
      'sv': "Försök igen",
    },
    'rifle': {
      'en': "Rifle",
      'fi': "Kivääri",
    },
    'romania': {
      'en': "Romania",
    },
    'romanian': {
      'en': "Romanian",
      'fi': "romania",
    },
    'russia': {
      'en': "Russia",
      'fi': "Venäjä",
    },
    'russian': {
      'en': "Russian",
      'fi': "venäjä",
    },
    'saved': {
      'en': "Saved",
      'fi': "Tallennetut",
      'sk': "Uložené",
      'sv': "Sparade",
    },
    'scan': {
      'en': "Scan",
      'fi': "Skannaa",
    },
    'scanThisWithAnotherDevice': {
      'en': "Scan this with another device to connect it to this game.",
      'fi': "Skannaa tämä toisella laitteella liittääksesi se tähän peliin.",
      'sk': "Oskenuj s druhým zariadením na pripojenie do tejto hry.",
    },
    'scotland': {
      'en': "Scotland",
    },
    'send': {
      'en': "Send",
      'fi': "Lähetä",
    },
    'sendFeedback': {
      'en': "Send feedback",
      'fi': "Lähetä palautetta",
      'sk': "Poslať pripomienku",
      'sv': "Skicka feedback",
    },
    'sendMessage': {
      'en': "Send a message",
      'fi': "Lähetä viesti",
      'sk': "Poslať správu",
      'sv': "Skicka ett meddelande",
    },
    'settings': {
      'en': "Settings",
      'fi': "Asetukset",
      'sk': "Nastavenia",
      'sv': "Inställningar",
    },
    'share': {
      'en': "Share",
      'fi': "Jaa",
      'sk': "Zdielať",
      'sv': "Delgiva",
    },
    'slovak': {
      'en': "Slovak",
      'fi': "slovakia",
    },
    'slovakia': {
      'en': "Slovakia",
    },
    'spain': {
      'en': "Spain",
      'fi': "Espanja",
    },
    'spanish': {
      'en': "Spanish",
      'fi': "espanja",
    },
    'sweden': {
      'en': "Sweden",
      'fi': "Ruotsi",
    },
    'swedish': {
      'en': "Swedish",
      'fi': "ruotsi",
      'sv': "svenska",
    },
    'switzerland': {
      'en': "Switzerland",
      'fi': "Sveitsi",
    },
    'team': {
      'en': "Team",
      'fi': "Joukkue",
      'sk': "Tím",
      'sv': "Lag",
    },
    'turret': {
      'en': "Turret",
      'fi': "Torni",
    },
    'ukraine': {
      'en': "Ukraine",
      'fi': "Ukraina",
    },
    'ukrainian': {
      'en': "Ukrainian",
      'fi': "ukraina",
    },
  // END STRINGS
  };
}
