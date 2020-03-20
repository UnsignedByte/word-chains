/*
* @Author: UnsignedByte
* @Date:   20:14:43, 19-Mar-2020
* @Last Modified by:   UnsignedByte
* @Last Modified time: 20:14:50, 19-Mar-2020
*/


// data = `$$datainput$$`;

// data = JSON.parse(data);


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