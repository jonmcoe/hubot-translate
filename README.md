## hubot-translate [![NPM version](https://badge.fury.io/js/hubot-translate.png)](http://badge.fury.io/js/hubot-translate)

Phrase translation via https://translate.yandex.com/

*Requires an API key*

### Usage

```
hubot translate me <phrase> - Translate <phrase> into English. <phrase>'s language is auto-detected
hubot translate me from <source> into <target> <phrase> - Translates <phrase> from <source> into <target>.
```

### Examples

```
hubot> hubot translate perro azul sin pantalones
"perro azul sin pantalones" in Spanish means "blue dog without pants" in English

hubot> hubot translate into french perro azul sin pantalones
"perro azul sin pantalones" in Spanish means "chien bleu sans pantalon" in French

hubot> hubot translate from french into esperanto chien bleu sans pantalon
"chien bleu sans pantalon" in French means "blua hundo sen pantalono" in Esperanto

hubot> hubot translate from esperanto into russian blua hundo sen pantalono
"blua hundo sen pantalono" in Esperanto means "синяя собака без штанов" in Russian

hubot> hubot translate синяя собака без штанов
"синяя собака без штанов" in Russian means "the blue dog with no pants" in English
```

### Installation
1. cd into your hubot dir, run `npm install --save hubot-translate` (adds it as a dependency in package.json).
2. Add `"hubot-translate"` to your `external-scripts.json` file.
3. Set an environment variable called YANDEX_KEY containing your key created here https://translate.yandex.com/
4. Restart Hubot

Steps 1 and 2 can be replaced by instead adding `hubot-translate.coffee` into your hubot's `scripts/` directory.

### Thanks to
- https://github.com/hubot-scripts/hubot-google-translate
  - Pretty much took the regex and interface wholesale from that project, which unfortunately no longer works because of Google API changes.

- https://translate.yandex.com/
  - An impressive free translation API