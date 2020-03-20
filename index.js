/*
* @Author: UnsignedByte
* @Date:   20:14:43, 19-Mar-2020
* @Last Modified by:   UnsignedByte
* @Last Modified time: 23:20:59, 19-Mar-2020
*/

const separators = ['!','\\.','\\?']; //Characters denoting the end of a line
const specialWords = ["mr\\.","ms\\.","mrs\\."]; //Words breaking this rule
const keptChars = ['\'']; //Characters to keep in words that aren't letters
const inlinepunc = [';',':','\u2014','\u2013',',']; //Punctuation that doesnt separate lines

function getLast(){ //retrieve last word
	let ta = $('#text')
	let text = ta.val().trimRight();
	ta.val(text);
	if (text.length == 0) return '__start__';
	let regStr = new RegExp(String.raw`(?<=\s|^)[^\s]+$`, 'g');
	text = text.match(regStr)[0];
	regStr = new RegExp(String.raw`(([a-zA-Z\d${keptChars.join()}]|${specialWords.join('|')}|${separators.join('|')}|${inlinepunc.join('|')}|\s)+.)+`, 'g');
	text.replace(regStr, '');
    // regStr = new RegExp(String.raw`((?<word>(?<=\s)[a-zA-Z${keptChars.join()}]+|${specialWords.join('|')})|(?<sep>${separators.join('|')})|(?<inline>${inlinepunc.join('|')}))$`, 'g');
    // console.log(regStr);

    let st = stype(text);
    // console.log(text, st);

    if (st[2]){
    	return text;
   	}else if (st[1]){
   		return text[text.length-1];
   	}else if (st[0]){
    	return '__start__';
    }else{
    	text.replace(new RegExp(String.raw`[^a-zA-Z\d${keptChars.join()}]+`, 'g'), '');
    	return text;
    }
}

function getNext(last){
	// console.log(last);
	let ta = $('#text');
	let text = ta.val();
	if (!(last in data.wordmap)){
		last = '__start__';
	}
	let nextL = data.matrix[data.wordmap[last]];
	if (typeof nextL === 'number') nextL = [nextL];
	let next = data.words[getRand(nextL)];
	let st = stype(next);
	// console.log(next, st);

	if ((st[0]||st[1]) && !st[2]){
		text += next;
	}else{
		text += " "+next;
	}
	ta.val(text.trim());
	ta.scrollTop(ta[0].scrollHeight)
}

function fillSentence(){
	let last = getLast();
	while (last === '__start__'){
		getNext(last);
		last = getLast();
	}

	while (last !== '__start__'){
		getNext(last);
		last = getLast();
	}
}

//get whether word has string, separator, etc.
function stype(text){
    let sep = separators.some((s)=>text.match(new RegExp(`${s}$`,'g')));
    let ilp = inlinepunc.some((s)=>text.match(new RegExp(`${s}$`,'g')));
    let spw = specialWords.some((s)=>text.match(new RegExp(`^${s}$`, 'g')));
    return [sep, ilp, spw];
}

function getRand(list){
	return list[Math.floor(list.length*Math.random())];
}

//allow typing tab for indent in textarea (taken from https://stackoverflow.com/questions/6637341/use-tab-to-indent-in-textarea)
$('#text').keydown(function(e) {
  var keyCode = e.keyCode || e.which;

  if (keyCode == 9) {
    e.preventDefault();
    var start = this.selectionStart;
    var end = this.selectionEnd;

    // set textarea value to: text before caret + tab + text after caret
    $(this).val($(this).val().substring(0, start)
                + "\t"
                + $(this).val().substring(end));

    // put caret at right position again
    this.selectionStart =
    this.selectionEnd = start + 1;
  }
});