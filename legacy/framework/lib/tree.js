/*
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: tree.js,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"
*/

var NN4 = false;
var Step = 20;
var i;
var LoadComplete = 0;

function setItemMax(max) {
        ItemMax = max;
}	

function setLoadComplete() {
	LoadComplete = 1;
}

// メニューの折り畳み/展開表示処理のメイン
function toggleShowItems(idx) {
  if (LoadComplete == 0) {
	return ;
  }

  // for Netscape6
  if (document.layers)
    NN4 = true;
  else if (document.getElementById && !document.all)
    document.all = document.getElementById;

  toggleShowFolder(idx, getTop(idx), true);
}

// フォルダ[idx]の中身を表示/非表示にする
// flag = true   トグル有効
//      = false  トグル無効
// フォルダかどうかのチェックは行なっていない。
function toggleShowFolder(idx, t, flag) {
  var baseTop = getTop(idx);
  var end = false;

  // フォルダ開き/閉じマークを反転する
  if (flag) {
    if (!(isOpened(idx)))
      openFolder(idx, true);
    else
	openFolder(idx, false);
  }

  // フォルダの中身の表示/非表示を反転する
  for (i = idx+1; i <= ItemMax; i++) {
    // 指定フォルダの内部かどうかを調べる
    if (getLeft(i) < getLeft(idx+1)) end = true;

    // フォルダ内部かどうかで分岐
    if (!end) {
      if ((flag && isVisible(i)) ||
          (!flag && !(isOpened(idx) && isVisible(idx)))) {
          // 表示されているので折り畳んで見えなくする
          turnStatus(i, false);
          setTop(i, baseTop);
      } else {
          // 表示されていないので表示する
          turnStatus(i, true);
          t += Step;
          setTop(i, t);
      }
      // もしフォルダならば中身表示の復元(再帰処理)
      if (isFolder(i)) t = toggleShowFolder(i, t, false);
    } else {
      if (!flag) {
        break;
      } else {
        // そのまま表示
	if (isVisible(i)) t += Step;
        setTop(i, t);
      }
    }
  }

  i--;
  return (t);
}

// フォルダの開いている/閉じている表示マークをセットする
function openFolder(idx, opened) {
  if (NN4)
    document.layers["m" + idx].document.images["i" + idx].src
      = opened ? 
      	"images/icon/png/o_triangle.png" : 
      	"images/icon/png/c_triangle.png";
  else
    document.images["i" + idx].src = opened ? 
    	"images/icon/png/o_triangle.png" : 
	"images/icon/png/c_triangle.png"; 
}

// アイテム[idx]が開かれている状態ならばtrue
// フォルダかどうかのチェックは行なっていない
function isOpened(idx) {
  return (/\/o_[^\/]*$/.test((NN4)?
            document.layers["m" + idx].document.images["i" + idx].src :
            document.images["i" + idx].src));
}

// アイテム[idx]がフォルダならばtrue
// 空のフォルダは存在しないことが前提
function isFolder(idx) {
  if (idx == ItemMax) return (false);
  return ((NN4)?
    (parseInt(document.layers["m"+idx].left) <
       parseInt(document.layers["m"+(idx+1)].left)) :
    (parseInt(document.all("m"+idx).style.left) <
       parseInt(document.all("m"+(idx+1)).style.left)));
}

// フォルダが実際に表示されているかいないかを返す
function isVisible(idx) {
  return ((NN4)?
            !(document.layers["m" + idx].visibility == "hide") :
            !(document.all("m" + idx).style.visibility == "hidden"));
}

function setTop(idx, t) {
  if (NN4)
    document.layers["m" + idx].top = t;
  else
    document.all("m" + idx).style.top = t+"px";
}

function getTop(idx) {
  return ((NN4)?
            parseInt(document.layers["m" + idx].top) :
            parseInt(document.all("m" + idx).style.top));
}

function setLeft(idx, l) {
  if (NN4)
    document.layers["m" + idx].left = l;
  else
    document.all("m" + idx).style.left = l;
}

function getLeft(idx) {
  return ((NN4)?
            parseInt(document.layers["m" + idx].left) :
            parseInt(document.all("m" + idx).style.left));
}

function turnStatus(idx, stat) {
  if (NN4)
    document.layers["m" + idx].visibility = (stat)? "show" : "hide";
  else
    document.all("m" + idx).style.visibility = (stat)? "visible" : "hidden";
}
