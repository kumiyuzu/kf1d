#!/bin/bash -xv
# SPDX-FileCopyrightText: 2026 Yuzuki KUMITA
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

### 1. 正常系: デフォルトオプション (-q 0.01 -r 1.0) ###
out=$(printf "10.5\n9.5\n" | ./kf1d)
[ "$?" = 0 ] || ng "$LINENO"
expected=$(printf "10.5\n9.997512437810945")
[ "$out" = "$expected" ] || ng "$LINENO"

### 2. 正常系: オプション指定 (-q 0.5 -r 0.5) ###
out=$(printf "10.0\n12.0\n" | ./kf1d -q 0.5 -r 0.5)
[ "$?" = 0 ] || ng "$LINENO"
expected=$(printf "10.0\n11.333333333333334")
[ "$out" = "$expected" ] || ng "$LINENO"

### 3. 正常系: 負の数・整数・前後空白を含む入力 ###
out=$(printf "  -5 \n -3.0 \n" | ./kf1d -q 0.0 -r 1.0)
[ "$?" = 0 ] || ng "$LINENO"
expected=$(printf -- "-5.0\n-4.0")
[ "$out" = "$expected" ] || ng "$LINENO"

### 4. 異常系: 数値以外の文字列 ###
out=$(printf "10.5\nabc\n" | ./kf1d 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "10.5" ] || ng "$LINENO"

### 5. 異常系: 空行を含む入力 ###
out=$(printf "10.5\n\n9.5\n" | ./kf1d 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"

### 6. 異常系: 空入力 (0行) ###
out=$(printf "" | ./kf1d 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"
[ "$out" = "" ] || ng "$LINENO"

### 7. 異常系: 不正なオプション値 (-q < 0, -r <= 0) ###
out=$(printf "10.0\n" | ./kf1d -q -0.1 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"

out=$(printf "10.0\n" | ./kf1d -r 0 2>/dev/null)
[ "$?" = 1 ] || ng "$LINENO"

[ "$res" = 0 ] && echo "OK"
exit $res
