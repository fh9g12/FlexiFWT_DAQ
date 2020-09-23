enc_padded = [zeros(1,length(enc)),enc,zeros(1,length(enc))];

diff = ones(1,length(enc_padded)-length(roll));
for i = 1:length(diff)
    diff(i) = sum((enc_padded(i:length(roll)+(i-1))-roll).^2);
end
[m,i] = min(diff)
(length(enc_padded)-length(roll))/2-i
figure(6)
plot(diff)