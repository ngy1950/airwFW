/**
 * Spotlight.js v0.4.0 (Bundle)
 * Copyright 2019 Nextapps GmbH
 * Author: Thomas Wilkerling
 * Licence: Apache-2.0
 * https://github.com/nextapps-de/spotlight
 */
(function() {
    'use strict';
    var aa = {};

    function ba(a) {
        for (var b = a.classList, c = {}, d = 0; d < b.length; d++) c[b[d]] = 1;
        a.a = c
    }

    function f(a, b) {
        a = ca(a);
        "string" === typeof b && (b = [b]);
        for (var c = 0; c < b.length; c++)
            for (var d = b[c], e = 0; e < a.length; e++) {
                var g = a[e];
                g.a || ba(g);
                g.a[d] || (g.a[d] = 1, g.classList.add(d))
            }
    }

    function h(a, b) {
        a = ca(a);
        "string" === typeof b && (b = [b]);
        for (var c = 0; c < a.length; c++)
            for (var d = a[c], e = 0; e < b.length; e++) {
                var g = b[e];
                d.a || ba(d);
                d.a[g] && (d.a[g] = 0, d.classList.remove(g))
            }
    }

    function k(a, b, c, d) {
        a = ca(a);
        if ("string" === typeof b)
            for (var e = 0; e < a.length; e++) {
                var g = a[e],
                    m = g.b;
                m || (g.b = m = {});
                m[b] !== c && (m[b] = c, g.style.setProperty(aa[b] || (aa[b] = b.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase()), c, d || null))
            } else
                for (e = Object.keys(b), g = 0; g < e.length; g++) {
                    m = e[g];
                    c = b[m];
                    for (var n = 0; n < a.length; n++) k(a[n], m, c, d)
                }
    }
    var da = 0;

    function ea(a, b, c) {
        k(a, "transition", "none");
        k(a, b, c);
        da || (da = a.clientTop && 0);
        k(a, "transition", "")
    }

    function ca(a) {
        if (a.constructor === Array) {
            for (var b = 0; b < a.length; b++) {
                var c = a[b];
                a[b] = "string" === typeof c ? document.querySelector(c) : c
            }
            return a
        }
        return "string" === typeof a ? document.querySelectorAll(a) : [a]
    }

    function l(a, b) {
        return (b || document).getElementsByClassName(a)
    };

    function fa(a, b, c, d) {
        ha("add", a, b, c, d)
    }

    function ia(a, b, c, d) {
        ha("remove", a, b, c, d)
    }

    function ha(a, b, c, d, e) {
        b[a + "EventListener"](c || "click", d, "undefined" === typeof e ? !0 : e)
    }

    function p(a, b) {
        a || (a = window.event);
        a && (b || a.preventDefault(), a.stopImmediatePropagation(), a.returnValue = !1);
        return !1
    };
    var ja = document.createElement("style");
    ja.innerHTML = "#spotlight,#spotlight .preloader,#spotlight .scene{top:0;width:100%;height:100%}#spotlight .arrow,#spotlight .icon{cursor:pointer;background-repeat:no-repeat}#spotlight,#spotlight .scene img{pointer-events:none;visibility:hidden}#spotlight{z-index:99999;color:#fff;background-color:#000;overflow:hidden;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;transition:visibility .25s ease,opacity .25s ease;font-family:Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;touch-action:none;-webkit-tap-highlight-color:transparent;position:fixed;opacity:0;contain:layout size paint style}#spotlight .arrow,#spotlight .footer,#spotlight .header{position:absolute;background-color:rgba(0,0,0,.45)}#spotlight.show{opacity:1;visibility:visible;pointer-events:auto;transition:none}#spotlight.show .pane,#spotlight.show .scene{will-change:transform}#spotlight.show .scene img{will-change:transform,opacity}#spotlight .preloader{visibility:hidden;position:absolute;opacity:0;background-position:center center;background-repeat:no-repeat;background-size:42px 42px}#spotlight.loading .preloader{transition:opacity .25s cubic-bezier(1,0,1,0);visibility:visible;opacity:1}#spotlight .pane,#spotlight .scene{position:absolute;contain:layout size style}#spotlight .scene{transition:transform 1s cubic-bezier(.1,1,.1,1);transition:transform 1s cubic-bezier(.1,1,.1,1),-webkit-transform 1s cubic-bezier(.1,1,.1,1)}#spotlight .scene img{display:inline-block;position:absolute;width:auto;height:auto;max-width:100%;max-height:100%;left:50%;top:50%;opacity:1;margin:0;padding:0;border:0;-webkit-transform:translate(-50%,-50%) scale(1) perspective(100vw);transform:translate(-50%,-50%) scale(1) perspective(100vw);transition:transform 1s cubic-bezier(.1,1,.1,1),opacity 1s cubic-bezier(.1,1,.1,1);transition:transform 1s cubic-bezier(.1,1,.1,1),opacity 1s cubic-bezier(.1,1,.1,1),-webkit-transform 1s cubic-bezier(.1,1,.1,1);-webkit-transform-style:preserve-3d;transform-style:preserve-3d;contain:layout paint style}#spotlight .pane{top:0;width:100%;height:100%}#spotlight .header{top:0;width:100%;height:50px;text-align:right;-webkit-transform:translateY(-100px);transform:translateY(-100px);transition:transform .35s cubic-bezier(0,0,.25,1);transition:transform .35s cubic-bezier(0,0,.25,1),-webkit-transform .35s cubic-bezier(0,0,.25,1);contain:layout size paint style}#spotlight .header:hover,#spotlight.menu .header{-webkit-transform:translateY(0);transform:translateY(0)}#spotlight .header div{display:inline-block;vertical-align:middle;white-space:nowrap;width:30px;height:50px;padding-right:20px;opacity:.5}#spotlight .footer{bottom:0;line-height:1.35em;padding:20px 25px;text-align:left;contain:layout paint style}#spotlight .footer .title{font-size:125%;padding-bottom:10px}#spotlight .page{float:left;width:auto;padding-left:20px;line-height:50px}#spotlight .icon{background-position:left center;background-size:21px 21px;transition:opacity .2s ease-out}#spotlight .fullscreen{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyLjUiIHZpZXdCb3g9Ii0xIC0xIDI2IDI2IiB3aWR0aD0iMjQiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZD0iTTggM0g1YTIgMiAwIDAgMC0yIDJ2M20xOCAwVjVhMiAyIDAgMCAwLTItMmgtM20wIDE4aDNhMiAyIDAgMCAwIDItMnYtM00zIDE2djNhMiAyIDAgMCAwIDIgMmgzIi8+PC9zdmc+)}#spotlight .fullscreen.on{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyLjUiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Ik04IDN2M2EyIDIgMCAwIDEtMiAySDNtMTggMGgtM2EyIDIgMCAwIDEtMi0yVjNtMCAxOHYtM2EyIDIgMCAwIDEgMi0yaDNNMyAxNmgzYTIgMiAwIDAgMSAyIDJ2MyIvPjwvc3ZnPg==)}#spotlight .autofit{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBoZWlnaHQ9Ijk2cHgiIHZpZXdCb3g9IjAgMCA5NiA5NiIgd2lkdGg9Ijk2cHgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggdHJhbnNmb3JtPSJyb3RhdGUoOTAgNTAgNTApIiBmaWxsPSIjZmZmIiBkPSJNNzEuMzExLDgwQzY5LjY3LDg0LjY2LDY1LjIzLDg4LDYwLDg4SDIwYy02LjYzLDAtMTItNS4zNy0xMi0xMlYzNmMwLTUuMjMsMy4zNC05LjY3LDgtMTEuMzExVjc2YzAsMi4yMSwxLjc5LDQsNCw0SDcxLjMxMSAgeiIvPjxwYXRoIHRyYW5zZm9ybT0icm90YXRlKDkwIDUwIDUwKSIgZmlsbD0iI2ZmZiIgZD0iTTc2LDhIMzZjLTYuNjMsMC0xMiw1LjM3LTEyLDEydjQwYzAsNi42Myw1LjM3LDEyLDEyLDEyaDQwYzYuNjMsMCwxMi01LjM3LDEyLTEyVjIwQzg4LDEzLjM3LDgyLjYzLDgsNzYsOHogTTgwLDYwICBjMCwyLjIxLTEuNzksNC00LDRIMzZjLTIuMjEsMC00LTEuNzktNC00VjIwYzAtMi4yMSwxLjc5LTQsNC00aDQwYzIuMjEsMCw0LDEuNzksNCw0VjYweiIvPjwvc3ZnPg==)}#spotlight .zoom-out{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSIwIDAgMjQgMjQiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIxMSIgY3k9IjExIiByPSI4Ii8+PGxpbmUgeDE9IjIxIiB4Mj0iMTYuNjUiIHkxPSIyMSIgeTI9IjE2LjY1Ii8+PGxpbmUgeDE9IjgiIHgyPSIxNCIgeTE9IjExIiB5Mj0iMTEiLz48L3N2Zz4=)}#spotlight .zoom-in{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSIwIDAgMjQgMjQiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIxMSIgY3k9IjExIiByPSI4Ii8+PGxpbmUgeDE9IjIxIiB4Mj0iMTYuNjUiIHkxPSIyMSIgeTI9IjE2LjY1Ii8+PGxpbmUgeDE9IjExIiB4Mj0iMTEiIHkxPSI4IiB5Mj0iMTQiLz48bGluZSB4MT0iOCIgeDI9IjE0IiB5MT0iMTEiIHkyPSIxMSIvPjwvc3ZnPg==)}#spotlight .theme{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBoZWlnaHQ9IjI0cHgiIHZlcnNpb249IjEuMiIgdmlld0JveD0iMiAyIDIwIDIwIiB3aWR0aD0iMjRweCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSIjZmZmIj48cGF0aCBkPSJNMTIsNGMtNC40MTgsMC04LDMuNTgyLTgsOHMzLjU4Miw4LDgsOHM4LTMuNTgyLDgtOFMxNi40MTgsNCwxMiw0eiBNMTIsMThjLTMuMzE0LDAtNi0yLjY4Ni02LTZzMi42ODYtNiw2LTZzNiwyLjY4Niw2LDYgUzE1LjMxNCwxOCwxMiwxOHoiLz48cGF0aCBkPSJNMTIsN3YxMGMyLjc1NywwLDUtMi4yNDMsNS01UzE0Ljc1Nyw3LDEyLDd6Ii8+PC9nPjwvc3ZnPg==)}#spotlight .player{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSItMC41IC0wLjUgMjUgMjUiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSIxMCIvPjxwb2x5Z29uIGZpbGw9IiNmZmYiIHBvaW50cz0iMTAgOCAxNiAxMiAxMCAxNiAxMCA4Ii8+PC9zdmc+)}#spotlight .player.on{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSItMC41IC0wLjUgMjUgMjUiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSIxMCIvPjxsaW5lIHgxPSIxMCIgeDI9IjEwIiB5MT0iMTUiIHkyPSI5Ii8+PGxpbmUgeDE9IjE0IiB4Mj0iMTQiIHkxPSIxNSIgeTI9IjkiLz48L3N2Zz4=)}#spotlight .close{background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSIyIDIgMjAgMjAiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48bGluZSB4MT0iMTgiIHgyPSI2IiB5MT0iNiIgeTI9IjE4Ii8+PGxpbmUgeDE9IjYiIHgyPSIxOCIgeTE9IjYiIHkyPSIxOCIvPjwvc3ZnPg==)}#spotlight .preloader{background-image:url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzgiIGhlaWdodD0iMzgiIHZpZXdCb3g9IjAgMCAzOCAzOCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiBzdHJva2U9IiNmZmYiPjxnIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+PGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMSAxKSIgc3Ryb2tlLXdpZHRoPSIyIiBzdHJva2Utb3BhY2l0eT0iLjY1Ij48Y2lyY2xlIHN0cm9rZS1vcGFjaXR5PSIuMTUiIGN4PSIxOCIgY3k9IjE4IiByPSIxOCIvPjxwYXRoIGQ9Ik0zNiAxOGMwLTkuOTQtOC4wNi0xOC0xOC0xOCI+PGFuaW1hdGVUcmFuc2Zvcm0gYXR0cmlidXRlTmFtZT0idHJhbnNmb3JtIiB0eXBlPSJyb3RhdGUiIGZyb209IjAgMTggMTgiIHRvPSIzNjAgMTggMTgiIGR1cj0iMXMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIi8+PC9wYXRoPjwvZz48L2c+PC9zdmc+)}#spotlight .arrow{top:50%;left:20px;width:50px;height:50px;border-radius:100%;margin-top:-25px;padding:10px;-webkit-transform:translateX(-100px);transform:translateX(-100px);transition:transform .35s cubic-bezier(0,0,.25,1),opacity .2s ease-out;transition:transform .35s cubic-bezier(0,0,.25,1),opacity .2s ease-out,-webkit-transform .35s cubic-bezier(0,0,.25,1);box-sizing:border-box;background-position:center center;background-size:30px 30px;opacity:.65;background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+PHN2ZyBmaWxsPSJub25lIiBoZWlnaHQ9IjI0IiBzdHJva2U9IiNmZmYiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgc3Ryb2tlLXdpZHRoPSIyIiB2aWV3Qm94PSIwIDAgMjQgMjQiIHdpZHRoPSIyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cG9seWxpbmUgcG9pbnRzPSIxNSAxOCA5IDEyIDE1IDYiLz48L3N2Zz4=)}#spotlight .arrow-right{left:auto;right:20px;-webkit-transform:translateX(100px) scaleX(-1);transform:translateX(100px) scaleX(-1)}#spotlight.menu .arrow-left{-webkit-transform:translateX(0);transform:translateX(0)}#spotlight.menu .arrow-right{-webkit-transform:translateX(0) scaleX(-1);transform:translateX(0) scaleX(-1)}#spotlight .arrow-left:hover,#spotlight .arrow-right:hover,#spotlight .icon:hover{opacity:1}#spotlight.white{color:#fff;background-color:#fff}#spotlight.white .arrow,#spotlight.white .footer,#spotlight.white .header,#spotlight.white .preloader{-webkit-filter:invert(1);filter:invert(1)}.hide-scrollbars{overflow:-moz-hidden-unscrollable;-ms-overflow-style:none}.hide-scrollbars::-webkit-scrollbar{width:0}@media (max-width:800px){#spotlight .header div{width:20px}#spotlight .footer{font-size:12px}#spotlight .arrow{width:35px;height:35px;margin-top:-17.5px;background-size:15px 15px}#spotlight .preloader{background-size:30px 30px}}@media (max-width:400px),(max-height:400px){#spotlight .fullscreen{display:none!important}}";
    document.getElementsByTagName("head")[0].appendChild(ja);
    var q = "theme fullscreen autofit zoom-in zoom-out page title description player".split(" "),
        r, t, ka, la, u, v, x, y, z, A = !1,
        B = !1,
        C = !1,
        D = !1,
        E = !1,
        F = !1,
        G, H, I, J, K, L, M, N, O, P, ma, na, oa, pa, Q, qa, R, S = null,
        T = null,
        U = null,
        V, ra;

    function sa(a, b) {
        if (H = a.length) {
            M || (M = l("pane", O));
            for (var c = M.length, d = I.title, e = I.description, g = 0; g < H; g++) {
                var m = a[g];
                if (g < c) var n = M[g];
                else n = M[0].cloneNode(!0), k(n, "left", 100 * g + "%"), M[0].parentNode.appendChild(n);
                var w = m.dataset,
                    Da = void 0;
                n = n.dataset;
                n.src = m.href || m.src || w.src || w.href;
                "false" !== d && (n.title = m.title || w && w.title || (Da = (m || document).getElementsByTagName("img")).length && Da[0].alt || d || "");
                "false" !== e && (n.description = m.description || w && w.description || e || "")
            }
            G = b || 1;
            ea(K, "transform", "translateX(-" +
                100 * (G - 1) + "%)");
            W()
        }
    }

    function X(a, b, c, d) {
        if (d || a[c]) I[c] = b && b[c] || d
    }

    function ta(a, b) {
        I = {};
        b && ua(b);
        ua(a);
        X(a, b, "description");
        X(a, b, "title");
        X(a, b, "prefetch", !0);
        X(a, b, "preloader", !0);
        J = I.infinite;
        if ((a = I.zoom) || "" === a) I["zoom-in"] = I["zoom-out"] = a, delete I.zoom;
        if ((a = I.control) || "" === a) {
            a = "string" === typeof a ? a.split(",") : a;
            for (b = 0; b < q.length; b++) I[q[b]] = "false";
            for (b = 0; b < a.length; b++) {
                var c = a[b].trim();
                "zoom" === c ? I["zoom-in"] = I["zoom-out"] = "true" : I[c] = "true"
            }
        }
        for (a = 0; a < q.length; a++) b = q[a], k(l(b, O)[0], "display", "false" === I[b] ? "none" : "");
        "white" === (F = I.theme) && va()
    }

    function ua(a) {
        for (var b = I, c = Object.keys(a), d = 0; d < c.length; d++) {
            var e = c[d];
            b[e] = "" + a[e]
        }
    }

    function wa() {
        var a = G;
        L = M[a - 1];
        N = L.firstElementChild;
        G = a;
        if (!N) {
            var b = "false" !== I.preloader;
            N = new Image;
            N.onload = function() {
                b && h(O, "loading");
                k(this, {
                    visibility: "visible",
                    opacity: 1,
                    transform: ""
                });
                "false" !== I.prefetch && a < H && ((new Image).src = M[a].dataset.src)
            };
            N.onerror = function() {
                L.removeChild(this)
            };
            L.appendChild(N);
            N.src = L.dataset.src;
            b && f(O, "loading");
            return !b
        }
        return !0
    }
    fa(document, "DOMContentLoaded", function() {
        O = document.createElement("div");
        O.id = "spotlight";
        O.innerHTML = '<div class=preloader></div><div class=scene><div class=pane></div></div><div class=header><div class=page></div><div class="icon rotateleft"></div><div class="icon rotateright"></div><div class="icon fullscreen"></div><div class="icon autofit"></div><div class="icon zoom-out"></div><div class="icon zoom-in"></div><div class="icon theme"></div><div class="icon player"></div><div class="icon close"></div></div><div class="arrow arrow-left"></div><div class="arrow arrow-right"></div><div class=footer><div class=title></div><div class=description></div></div>';
        k(O, "transition", "none");
        document.body.appendChild(O);
        K = l("scene", O)[0];
        P = l("footer", O)[0];
        ma = l("title", P)[0];
        na = l("description", P)[0];
        oa = l("arrow-left", O)[0];
        pa = l("arrow-right", O)[0];
        Q = l("fullscreen", O)[0];
        qa = l("page", O)[0];
        R = l("player", O)[0];
        V = document.documentElement || document.body;
        document.cancelFullScreen || (document.cancelFullScreen = document.exitFullscreen || document.webkitCancelFullScreen || document.webkitExitFullscreen || document.mozCancelFullScreen || function() {});
        V.requestFullScreen || (V.requestFullScreen =
            V.webkitRequestFullScreen || V.msRequestFullScreen || V.mozRequestFullScreen || k(Q, "display", "none") || function() {});
        ra = [
            [window, "keydown", xa],
            [window, "wheel", ya],
            [window, "hashchange", za],
            [K, "mousedown", Aa],
            [K, "mouseleave", Ba],
            [K, "mouseup", Ba],
            [K, "mousemove", Ca],
            [K, "touchstart", Aa, {
                passive: !0
            }],
            [K, "touchcancel", Ba],
            [K, "touchend", Ba],
            [K, "touchmove", Ca, {
                passive: !0
            }],
            [Q, "", Ea],
            [oa, "", Fa],
            [pa, "", Y],
            [R, "", Ga],
            [l("autofit", O)[0], "", Ha],
            [l("zoom-in", O)[0], "", Ia],
            [l("zoom-out", O)[0], "", Ja],
            [l("close", O)[0], "",
                Ka
            ],
            [l("theme", O)[0], "", va]
        ];
        fa(document, "", La)
    }, {
        once: !0
    });

    function Ma(a) {
        for (var b = 0; b < ra.length; b++) {
            var c = ra[b];
            (a ? fa : ia)(c[0], c[1], c[2], c[3])
        }
    }

    function La(a) {
        var b = Na.call(a.target, ".spotlight");
        if (b) {
            var c = Na.call(b, ".spotlight-group"),
                d = l("spotlight", c);
            ta(b.dataset, c && c.dataset);
            for (c = 0; c < d.length; c++)
                if (d[c] === b) {
                    sa(d, c + 1);
                    break
                } Oa();
            return p(a)
        }
    }

    function xa(a) {
        if (L) switch (a.keyCode) {
            case 8:
                Ha();
                break;
            case 27:
                Ka();
                break;
            case 32:
                "false" !== I.player && Ga();
                break;
            case 37:
                Fa();
                break;
            case 39:
                Y();
                break;
            case 38:
            case 107:
            case 187:
                Ia();
                break;
            case 40:
            case 109:
            case 189:
                Ja()
        }
    }

    function ya(a) {
        L && (a = a.deltaY, 0 > .5 * (0 > a ? 1 : a ? -1 : 0) ? Ja() : Ia())
    }

    function za() {
        L && "#spotlight" === location.hash && Ka(!0)
    }

    function Ga(a) {
        ("boolean" === typeof a ? a : !S) ? S || (S = setInterval(Y, 1 * I.player || 5E3), f(R, "on")): S && (S = clearInterval(S), h(R, "on"));
        return S
    }

    function Z() {
        U ? clearTimeout(U) : f(O, "menu");
        var a = I.autohide;
        U = "false" !== a ? setTimeout(function() {
            h(O, "menu");
            U = null
        }, 1 * a || 2E3) : 1
    }

    function Pa(a) {
        "boolean" === typeof a && (U = a ? U : 0);
        U ? (U = clearTimeout(U), h(O, "menu")) : Z();
        return p(a)
    }

    function Aa(a) {
        A = !0;
        B = !1;
        var b = Qa(a);
        u = document.body.clientWidth;
        v = document.body.clientHeight;
        x = N.width * z;
        y = N.height * z;
        C = x <= u;
        ka = b.x;
        la = b.y;
        return p(a, !0)
    }

    function Ba(a) {
        if (A && !B) return A = !1, Pa(a);
        C && B && (ea(K, "transform", "translateX(" + -(100 * (G - 1) - r / u * 100) + "%)"), r < -(v / 10) && Y() || r > v / 10 && Fa() || k(K, "transform", "translateX(-" + 100 * (G - 1) + "%)"), r = 0, C = !1, k(L, "transform", ""));
        A = !1;
        return p(a)
    }

    function Ca(a) {
        if (A) {
            T || (T = requestAnimationFrame(Ra));
            var b = Qa(a),
                c = (x - u) / 2;
            B = !0;
            C = x <= u;
            r -= ka - (ka = b.x);
            C ? D = !0 : r > c ? r = c : 0 < u - r - x + c ? r = u - x + c : D = !0;
            y > v && (c = (y - v) / 2, t -= la - (la = b.y), t > c ? t = c : 0 < v - t - y + c ? t = v - y + c : D = !0)
        } else Z();
        return p(a, !0)
    }

    function Qa(a) {
        var b = a.touches;
        b && (b = b[0]);
        return {
            x: b ? b.clientX : a.pageX,
            y: b ? b.clientY : a.pageY
        }
    }

    function Ra(a) {
        D ? (a && (T = requestAnimationFrame(Ra)), k(L, "transform", "translate(" + r + "px, " + t + "px)")) : T = null;
        D = !1
    }

    function Ea(a) {
        (a = "boolean" === typeof a ? a : document.isFullScreen || document.webkitIsFullScreen || document.mozFullScreen) ? (document.cancelFullScreen(), h(Q, "on")) : (V.requestFullScreen(), f(Q, "on"));
        return !a
    }

    function Ha(a) {
        "boolean" === typeof a && (E = !a);
        E = 1 === z && !E;
        k(N, {
            maxHeight: E ? "none" : "",
            maxWidth: E ? "none" : "",
            transform: ""
        });
        z = 1;
        t = r = 0;
        D = !0;
        Ra();
        Z()
    }

    function Ia(a) {
        Sa(z /= .65);
        a || Z()
    }

    function Sa(a) {
        k(N, "transform", "translate(-50%, -50%) scale(" + (a || 1) + ")")
    }

    function Ja(a) {
        var b = .65 * z;
        1 > b && (b = 1);
        b !== z && (Sa(z = b), t = r = 0, D = !0, Ra());
        a || Z()
    }

    function Oa() {
        location.hash = "spotlight";
        location.hash = "show";
        Ma(!0);
        k(O, "transition", "");
        f(V, "hide-scrollbars");
        f(O, "show");
        Z()
    }

    function Ka(a) {
        Ma(!1);
        history.go(!0 === a ? -1 : -2);
        h(V, "hide-scrollbars");
        h(O, "show");
        S && Ga(!1);
        N.parentNode.removeChild(N);
        N = L = null
    }

    function Fa() {
        S || Z();
        if (1 < G) return G--, W(!1), !0;
        if (S || J) return Ta(H)
    }

    function Y() {
        S || Z();
        if (G < H) return G++, W(!0), !0;
        if (S || J) return Ta(1)
    }

    function Ta(a) {
        if (a !== G) {
            S || Z();
            var b = a > G;
            G = a;
            W(b);
            return !0
        }
    }

    function va(a) {
        "boolean" === typeof a ? F = a : (F = !F, Z());
        F ? f(O, "white") : h(O, "white")
    }

    function W(a) {
        t = r = 0;
        z = 1;
        var b = I.animation,
            c = !0,
            d = !0,
            e = !0,
            g = !1;
        if (b || "" === b) {
            g = e = d = c = !1;
            b = b.split(",");
            for (var m = 0; m < b.length; m++) {
                var n = b[m].trim();
                "scale" === n ? c = !0 : "fade" === n ? d = !0 : "slide" === n ? e = !0 : "rotate" === n && (g = !0)
            }
        }
        k(K, "transition", e ? "" : "none");
        k(K, "transform", "translateX(-" + 100 * (G - 1) + "%)");
        L && k(L, "transform", "");
        if (N) {
            k(N, {
                opacity: d ? 0 : 1,
                transform: ""
            });
            var w = N;
            setTimeout(function() {
                w && N !== w && w.parentNode && w.parentNode.removeChild(w)
            }, 800)
        }
        e = wa();
        ea(N, {
            opacity: d ? 0 : 1,
            transform: "translate(-50%, -50%)" +
                (c ? " scale(0.8)" : "") + (g && "undefined" !== typeof a ? " rotateY(" + (a ? "" : "-") + "90deg)" : ""),
            maxHeight: "",
            maxWidth: ""
        });
        e && k(N, {
            visibility: "visible",
            opacity: 1,
            transform: ""
        });
        k(L, "transform", "");
        k(oa, "visibility", J || 1 !== G ? "" : "hidden");
        k(pa, "visibility", J || G !== H ? "" : "hidden");
        a = L.dataset;
        if (c = a.title || a.description) ma.textContent = a.title || "", na.textContent = a.description || "";
        k(P, "visibility", c ? "visible" : "hidden");
        qa.textContent = G + " / " + H
    }
    var Na = Element.prototype.closest || function(a) {
        var b = this;
        for (a = a.substring(1); b && 1 === b.nodeType;) {
            if (b.classList.contains(a)) return b;
            b = b.parentElement || b.parentNode
        }
    };
    window.Spotlight = {
        theme: va,
        fullscreen: Ea,
        autofit: Ha,
        next: Y,
        prev: Fa,
        "goto": Ta,
        close: Ka,
        zoom: Sa,
        menu: Pa,
        show: function(a, b) {
            setTimeout(function() {
                a ? (b ? ta(b) : b = {}, sa(a, b.index)) : I = {};
                Oa()
            })
        },
        play: Ga
    };
}).call(this);