# Description:
#   Translate phrases to/from a variety of languages
#
# Configuration:
#   YANDEX_KEY: your API key with https://translate.yandex.com
#   DEBUG: flag for verbose errors
#
# Commands:
#   hubot translate me <phrase> - Translate <phrase> into English. <phrase>'s language is auto-detected
#   hubot translate me from <source> into <target> <phrase> - Translates <phrase> from <source> into <target>.
#
# The "me" in "translate me" is entirely optional and has no effect. 
# Both <source> and <target> are optional. Source defaults to auto-detect, target defaults to English
#
# Powered by https://translate.yandex.com/developers
# Bring your own API key and set it via env var `YANDEX_KEY`. 
# Be sure to give Yandex credit in your organization!
#
# Author: Jon Coe

LANGUAGES =
  "az": "Azerbaijan",
  "sq": "Albanian",
  "am": "Amharic",
  "en": "English",
  "ar": "Arabic",
  "hy": "Armenian",
  "af": "Afrikaans",
  "eu": "Basque",
  "ba": "Bashkir",
  "be": "Belarusian",
  "bn": "Bengali",
  "my": "Burmese",
  "bg": "Bulgarian",
  "bs": "Bosnian",
  "cy": "Welsh",
  "hu": "Hungarian",
  "vi": "Vietnamese",
  "ht": "Haitian",
  "gl": "Galician",
  "nl": "Dutch",
  "mrj": "Hill Mari",
  "el": "Greek",
  "ka": "Georgian",
  "gu": "Gujarati",
  "da": "Danish",
  "he": "Hebrew",
  "yi": "Yiddish",
  "id": "Indonesian",
  "ga": "Irish",
  "it": "Italian",
  "is": "Icelandic",
  "es": "Spanish",
  "kk": "Kazakh",
  "kn": "Kannada",
  "ca": "Catalan",
  "ky": "Kyrgyz",
  "zh": "Chinese",
  "ko": "Korean",
  "xh": "Xhosa",
  "km": "Khmer",
  "lo": "Laotian",
  "la": "Latin",
  "lv": "Latvian",
  "lt": "Lithuanian",
  "lb": "Luxembourgish",
  "mg": "Malagasy",
  "ms": "Malay",
  "ml": "Malayalam",
  "mt": "Maltese",
  "mk": "Macedonian",
  "mi": "Maori",
  "mr": "Marathi",
  "mhr": "Mari",
  "mn": "Mongolian",
  "de": "German",
  "ne": "Nepali",
  "no": "Norwegian",
  "pa": "Punjabi",
  "pap": "Papiamento",
  "fa": "Persian",
  "pl": "Polish",
  "pt": "Portuguese",
  "ro": "Romanian",
  "ru": "Russian",
  "ceb": "Cebuano",
  "sr": "Serbian",
  "si": "Sinhala",
  "sk": "Slovakian",
  "sl": "Slovenian",
  "sw": "Swahili",
  "su": "Sundanese",
  "tg": "Tajik",
  "th": "Thai",
  "tl": "Tagalog",
  "ta": "Tamil",
  "tt": "Tatar",
  "te": "Telugu",
  "tr": "Turkish",
  "udm": "Udmurt",
  "uz": "Uzbek",
  "uk": "Ukrainian",
  "ur": "Urdu",
  "fi": "Finnish",
  "fr": "French",
  "hi": "Hindi",
  "hr": "Croatian",
  "cs": "Czech",
  "sv": "Swedish",
  "gd": "Scottish",
  "et": "Estonian",
  "eo": "Esperanto",
  "jv": "Javanese",
  "ja": "Japanese"

ALIASES = 
  "deutsche": "de",
  "espańol": "es",
  "espanol": "es",
  "creole": "ht",

language_choices = (language for _, language of LANGUAGES).join('|')
alias_choices = (alias for alias, _ of ALIASES).join('|')
all_choices = language_choices + '|' + alias_choices


getCode = (language) ->
  for code, lang of LANGUAGES
      return code if lang.toLowerCase() is language.toLowerCase()

  for lang, code of ALIASES
      return code if lang.toLowerCase() is language.toLowerCase()


module.exports = (robot) ->

  pattern = new RegExp('translate(?: me)?' +
                       "(?: from (#{all_choices}))?" +
                       "(?: (?:in)?to (#{all_choices}))?" +
                       '(.*)', 'i')
  robot.respond pattern, (msg) ->
    term   = "\"#{msg.match[3]?.trim()}\""
    origin = if msg.match[1] isnt undefined then getCode(msg.match[1]) else null
    target = if msg.match[2] isnt undefined then getCode(msg.match[2]) else 'en'

    lang = if origin then origin + '-' + target else target
    msg.http("https://translate.yandex.net/api/v1.5/tr.json/translate")
      .query({
        key: process.env.YANDEX_KEY
        text: term
        lang: lang
      })
      .get() (err, res, body) ->
        if err
          msg.send "Failed to connect"
          return
        try
          parsed = JSON.parse body
          split = parsed['lang'].split '-'
          before = LANGUAGES[split[0]]
          after = LANGUAGES[split[1]]
          msg.send "#{term} in #{before} means #{parsed['text'][0]} in #{after}"
        catch e
          error = if process.env.DEBUG then body + ' ' + e else 'error'
          msg.send error
