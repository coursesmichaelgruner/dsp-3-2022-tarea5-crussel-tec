clearvars;
pkg load signal;
pkg load symbolic;

warning('off','all');

ai=audioinfo('la_muerte_del_angel_power_noise.wav');
Fs=ai.SampleRate;
Fn=Fs/2;
disp("Sample Rate:"),disp(Fs);
disp("Nyquist Rate:"),disp(Fn);

au=audioread('la_muerte_del_angel.wav');
an=audioread('la_muerte_del_angel_power_noise.wav');

f=fft(au);
fn=fft(an);

len=(length(fn)/2)-1;

x=[0:Fn/len:Fn];

clf;
figure(1);
semilogy(x,abs(fn(1:length(fn)/2)));
hold on;
semilogy(x,abs(f(1:length(f)/2)));
xlim([0 Fn]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Whole-file spectrum");

figure(2);
lf=1000;
num=round(lf*(length(fn)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn(1:num)));
hold on;
semilogy(x2,abs(f(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Reduced spectrum (1-1000 Hz)");

figure(3);
start=100000;
window=20000;
f2=fft(au(start:start+window));
fn2=fft(an(start:start+window));
num=round(lf*(length(fn2)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn2(1:num)));
hold on;
semilogy(x2,abs(f2(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Window 1 (100000-120000)");

figure(4);
start=200000;
window=20000;
f2=fft(au(start:start+window));
fn2=fft(an(start:start+window));
num=round(lf*(length(fn2)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn2(1:num)));
hold on;
semilogy(x2,abs(f2(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Window 2 (200000-220000)");

figure(5);
start=300000;
window=20000;
f2=fft(au(start:start+window));
fn2=fft(an(start:start+window));
num=round(lf*(length(fn2)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn2(1:num)));
hold on;
semilogy(x2,abs(f2(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Window 3 (300000-320000)");

figure(6);
start=400000;
window=20000;
f2=fft(au(start:start+window));
fn2=fft(an(start:start+window));
num=round(lf*(length(fn2)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn2(1:num)));
hold on;
semilogy(x2,abs(f2(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Original");
title("Window 4 (400000-420000)");

figure(7);
b=[1, -1.99993831529, 1];
a=[1, -1.97993893214, 0.9801];
[h,w]=freqz(b, a,lf,lf);
freqz_plot(w,h,0);

figure(8);
zplane(b,a);

figure(9);
y=filter (b,a,an);
fy=fft(y);
lf=1000;
num=round(lf*(length(fn)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn(1:num)));
hold on;
semilogy(x2,abs(fy(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Filtered");
title("Single-pole Filtered Reduced spectrum (1-1000 Hz)");

figure(10);
syms z;
numerator=1;
denominator=1;
for n=1:2:7;
  numerator*=(z^2-2*cos(2*pi*n*60/Fs)*z + 1);
  denominator*=(z^2-1.98*cos(2*pi*n*60/Fs)*z + 0.9801);
endfor
output_precision(8);
b=flip(double(coeffs(expand(numerator))))
a=flip(double(coeffs(expand(denominator))))
[h,w]=freqz(b,a,Fn,Fs);
freqz_plot(w,h,0);
title("Odd harmonic filter");
axH=findall(gcf,'type','axes');
set(axH,'xlim',[0 lf]);

y=filter (b,a,an);

figure(11)
zplane(b,a);
title("Odd harmonic filter");

figure(12);
numerator=1;
denominator=1;
for n=2:2:8;
  numerator*=(z^2-2*cos(2*pi*n*60/Fs)*z + 1);
  denominator*=(z^2-1.98*cos(2*pi*n*60/Fs)*z + 0.9801);
endfor
output_precision(8);
b=flip(double(coeffs(expand(numerator))))
a=flip(double(coeffs(expand(denominator))))
[h,w]=freqz(b,a,Fn,Fs);
freqz_plot(w,h,0);
title("Even harmonic filter");
axH=findall(gcf,'type','axes');
set(axH,'xlim',[0 lf]);

figure(13)
zplane(b,a);
title("Even harmonic filter");


figure(14);
y=filter (b,a,y);
fy=fft(y);
lf=1000;
num=round(lf*(length(fn)/2)/Fn);
x2=[0:lf/(num-1):lf];
semilogy(x2,abs(fn(1:num)));
hold on;
semilogy(x2,abs(fy(1:num)));
xlim([0 lf]);
xlabel("Frequency (Hz)");
ylabel ("Amplitude");
legend("Noisy","Filtered");
title("Fully Filtered Reduced spectrum (1-1000 Hz)");

%{
p=audioplayer(an,Fs);
playblocking(p);

p=audioplayer(y,Fs);
playblocking(p);

p=audioplayer(au,Fs);
playblocking(p);
%}

audiowrite('filtered.wav', y, Fs);
