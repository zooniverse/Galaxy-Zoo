# Code to generate inline web workers for MW Viewer

Workers =
  
  # TODO: Variables should be shortened manually.  Any JS compressor won't minify this.
  Histogram: [
    "var computeHistogram;",

    "computeHistogram = function(min, max, bins, data) {",
      "var arrayType, binSize, diff, flotHistogram, histogram, index, mean, numpixels, pixel, range, std, step, sum, values, _i, _j, _len, _len1, upper, value, number;",
      "range = max - min;",
      "binSize = range / bins;",
      "numpixels = data.length;",
      "if (numpixels < 256) {",
        "arrayType = Uint8Array;",
      "} else if (numpixels < 65535) {",
        "arrayType = Uint16Array;",
      "} else {",
        "arrayType = Uint32Array;",
      "}",
      "sum = 0;",
      "histogram = new arrayType(bins + 1);",
      "flotHistogram = new Array(bins + 1);",
      "for (_i = 0, _len = data.length; _i < _len; _i++) {",
        "pixel = data[_i];",
        "sum += pixel;",
        "index = Math.floor(((pixel - min) / range) * bins);",
        "histogram[index] += 1;",
        "step = min + binSize * index;",
        "flotHistogram[index] = [step, histogram[index]];",
      "}",
      "mean = sum / numpixels;",
      "sum = 0;",
      "for (_j = 0, _len1 = flotHistogram.length; _j < _len1; _j++) {",
        "values = flotHistogram[_j];",
        "if (values == null) {",
          "continue;",
        "}",
        "diff = values[0] - mean;",
        "sum += (diff * diff) * values[1];",
      "}",
      "std = Math.sqrt(sum / numpixels);",
      
      "for (i = 0; i < flotHistogram.length; i += 1) {",
        "values = flotHistogram[flotHistogram.length - i - 1];",
        "if (values == null) {",
          "continue;",
        "}",
        "value = values[0];",
        "number = values[1];",
        "upper = (sum - number * value) / sum;",
        "if (upper <= 0.9975) {",
          "break;",
        "}",
      "}",
      
      "return [flotHistogram, mean, std, upper];",
    "};",
    
    "self.addEventListener('message', (function (e) {",
      "var data, msg;",
      "data = e.data;",
      "var stats;",

      "stats = computeHistogram(data.min, data.max, data.bins, data.data);",
      
      "msg = {histogram: stats[0], mean: stats[1], std: stats[2], band: data.band, upper: stats[3]};",
      "self.postMessage(msg);",
    "}), false);"
  ].join("\n")

module?.exports = Workers