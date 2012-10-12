# Code to generate inline web workers for MW Viewer

Workers =
  Histogram: =>
    computeStatistics = (min, max, bins, data) =>
      range = max - min
      binSize = range / bins
      numPixels = data.length
      numNaNs = 0
      sum = 0
      
      # Initialize array
      histogram = new Array(bins + 1)
      for value, index in histogram
        step = binSize * index
        histogram[index] = [step, 0]
      
      for value, index in data
        if isNaN(value)
          numNaNs += 1
          continue
        sum += value
        index = Math.floor(((value - min) / range) * bins)
        histogram[index][1] += 1
      
      mean = sum / (numPixels - numNaNs)
      
      # Recompute sum to be offset by min
      sum = 0
      sorted = [] # Push to JS array to use the default sort
      for value in data
        value -= min
        sum += value
        sorted.push value
      sorted = sorted.sort()
      
      # Compute percentiles
      [lower, upper] = [0.25, 0.75]
      
      running = 0
      for value, index in sorted
        running += value
        percentile = running / sum
        if percentile > lower
          lower = sorted[index - 1] + min
          break
      
      running = 0
      for value, index in sorted
        running += value
        percentile = running / sum
        if percentile > upper
          upper = sorted[index - 1] + min
          break
      
      return [histogram, mean, lower, upper]
      
    self.addEventListener "message", ((e) ->
      data = e.data
      [histogram, mean, lower, upper] = computeStatistics(data.min, data.max, data.bins, data.data)
      msg =
        histogram: histogram
        mean: mean
        lower: lower
        upper: upper
        band: data.band

      self.postMessage(msg)
    ), false
    
  # TODO: Variables should be shortened manually.  Any JS compressor won't minify this.
  HistogramOld: [
    
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
      
      "return [flotHistogram, mean, std];",
    "};",
    
    "self.addEventListener('message', (function (e) {",
      "var data, msg;",
      "data = e.data;",
      "var stats;",

      "stats = computeHistogram(data.min, data.max, data.bins, data.data);",
      
      "msg = {histogram: stats[0], mean: stats[1], std: stats[2], band: data.band};",
      "self.postMessage(msg);",
    "}), false);"
  ].join("\n")

module?.exports = Workers