# Code to generate inline web workers for MW Viewer
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
  [lower, upper] = [0.0025, 0.9975]
  
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
