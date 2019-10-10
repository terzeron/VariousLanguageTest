areaTriangle a b c = result
    where
    result = sqrt(s * (s - a) * (s - b) * (s - c))
    s = (a + b + c) / 2
-- areaTriangle 3 4 5
