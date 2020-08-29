fs = 1e6;
n=50


for k = n

filename = sprintf('NMRanalysis1043_445G_%d.mat',k);
load(filename, 'variable');

% Separate data
time = variable(:, 1);
nmr_sp = variable(:, 4);
nmr_op = variable(:, 3);

%Define signal
t = time-1;

%Take fourier transform
fftSignal = fft(nmr_op);
fftSignal2 = fft(nmr_sp);
%apply fftshift to put it in the form we are used to (see documentation)
fftSignal = fftshift(fftSignal);
fftSignal2 = fftshift(fftSignal2);
%Next, calculate the frequency axis, which is defined by the sampling rate
f = fs/2*linspace(-1,1,fs*0.1);
%Since the signal is complex, we need to plot the magnitude to get it to
%look right, so we use abs (absolute value)
x = abs(fftSignal);
x2 = abs(fftSignal2);
figure;
plot(f, x2, f, x);
title('magnitude FFT of NMR signal');
xlabel('Frequency (Hz)');
ylabel('magnitude');
xlim([-1.5e4 1.5e4]);
legend('SP', 'OP');
ylim([0 350]);
end;