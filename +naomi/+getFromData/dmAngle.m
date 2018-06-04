function angle = dmAngle(data) 
    angle = data.getKey(naomi.KEYS.DMANGLE, 0.0)+ data.getKey(naomi.KEYS.DMANGLEOFFSET, 0.0);
end