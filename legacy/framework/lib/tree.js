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

// ��˥塼���ޤ����/Ÿ��ɽ�������Υᥤ��
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

// �ե����[idx]����Ȥ�ɽ��/��ɽ���ˤ���
// flag = true   �ȥ���ͭ��
//      = false  �ȥ���̵��
// �ե�������ɤ����Υ����å��ϹԤʤäƤ��ʤ���
function toggleShowFolder(idx, t, flag) {
  var baseTop = getTop(idx);
  var end = false;

  // �ե��������/�Ĥ��ޡ�����ȿž����
  if (flag) {
    if (!(isOpened(idx)))
      openFolder(idx, true);
    else
	openFolder(idx, false);
  }

  // �ե��������Ȥ�ɽ��/��ɽ����ȿž����
  for (i = idx+1; i <= ItemMax; i++) {
    // ����ե�������������ɤ�����Ĵ�٤�
    if (getLeft(i) < getLeft(idx+1)) end = true;

    // �ե�����������ɤ�����ʬ��
    if (!end) {
      if ((flag && isVisible(i)) ||
          (!flag && !(isOpened(idx) && isVisible(idx)))) {
          // ɽ������Ƥ���Τ��ޤ����Ǹ����ʤ�����
          turnStatus(i, false);
          setTop(i, baseTop);
      } else {
          // ɽ������Ƥ��ʤ��Τ�ɽ������
          turnStatus(i, true);
          t += Step;
          setTop(i, t);
      }
      // �⤷�ե�����ʤ�����ɽ��������(�Ƶ�����)
      if (isFolder(i)) t = toggleShowFolder(i, t, false);
    } else {
      if (!flag) {
        break;
      } else {
        // ���Τޤ�ɽ��
	if (isVisible(i)) t += Step;
        setTop(i, t);
      }
    }
  }

  i--;
  return (t);
}

// �ե�����γ����Ƥ���/�Ĥ��Ƥ���ɽ���ޡ����򥻥åȤ���
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

// �����ƥ�[idx]��������Ƥ�����֤ʤ��true
// �ե�������ɤ����Υ����å��ϹԤʤäƤ��ʤ�
function isOpened(idx) {
  return (/\/o_[^\/]*$/.test((NN4)?
            document.layers["m" + idx].document.images["i" + idx].src :
            document.images["i" + idx].src));
}

// �����ƥ�[idx]���ե�����ʤ��true
// ���Υե������¸�ߤ��ʤ����Ȥ�����
function isFolder(idx) {
  if (idx == ItemMax) return (false);
  return ((NN4)?
    (parseInt(document.layers["m"+idx].left) <
       parseInt(document.layers["m"+(idx+1)].left)) :
    (parseInt(document.all("m"+idx).style.left) <
       parseInt(document.all("m"+(idx+1)).style.left)));
}

// �ե�������ºݤ�ɽ������Ƥ��뤫���ʤ������֤�
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
