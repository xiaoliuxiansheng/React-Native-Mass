/**
 * @name: index
 * @author: LIULIU
 * @date: 2020-07-21 14:45
 * @description：index
 * @update: 2020-07-21 14:45
 */
// 防抖
DEBOUNCE = (fn, wait) => {
    var timeout = null;
    return function () {
        if (timeout !== null) clearTimeout(timeout);
        timeout = setTimeout(fn, wait);
    }
}

// 节流
THROTTLE = (func, delay) => {
    var prev = Date.now();
    return function () {
        var context = this;
        var args = arguments;
        var now = Date.now();
        if (now - prev >= delay) {
            func.apply(context, args);
            prev = Date.now();
        }
    }
}
