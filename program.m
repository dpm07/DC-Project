% DIGITAL SIGNAL DISTORTION USING EYE DIAGRAM
% B.Tech ENTC - Digital Communication Macro-Project

clc;
clear;
close all;

%% 1. USER INPUT

fprintf('\n============================================\n');
fprintf(' DIGITAL SIGNAL DISTORTION USING EYE DIAGRAM\n');
fprintf('============================================\n');

fprintf('\nSelect Input Data:\n');
fprintf('1. Random Binary Data\n');
fprintf('2. Enter Binary Data Manually\n');

choice = input('Enter your choice (1 or 2): ');

if choice == 2

    bits = input('Enter binary sequence (example: [1 1 0 0 1 0]): ');

    % Check that input contains only 0 and 1
    if any(bits ~= 0 & bits ~= 1)
        error('Input must contain only 0 and 1.');
    end

    N = length(bits);

else

    N = input('Enter number of bits (minimum 6): ');

    if N < 6
        error('Number of bits must be at least 6.');
    end

    rng(1);
    bits = randi([0 1],1,N);

end

SNR = input('Enter AWGN SNR in dB (example: 10): ');

alphaPercent = input('Enter ISI strength in % (example: 30): ');

alpha = alphaPercent/100;


%% 2. SIMULATION PARAMETERS

Tb = 1e-3;                    % Bit duration = 1 ms
Rb = 1/Tb;                    % Bit rate = 1 kbps

samplesPerSymbol = 5;         % Samples per bit
Fs = Rb*samplesPerSymbol;     % Sampling frequency

numberOfTraces = 5;           % Number of eye segments

isiDelay = 2;                 % ISI delay in samples


%% 3. DISPLAY INPUT DATA

fprintf('\n============================================\n');
fprintf(' SIMULATION PARAMETERS\n');
fprintf('============================================\n');

fprintf('Input bits           : ');
fprintf('%d ',bits);
fprintf('\n');

fprintf('Number of bits       : %d\n',N);
fprintf('Bit duration         : %.4f s\n',Tb);
fprintf('Bit rate             : %.0f bits/s\n',Rb);
fprintf('Samples per symbol   : %d\n',samplesPerSymbol);
fprintf('Sampling frequency   : %.0f Hz\n',Fs);
fprintf('AWGN SNR             : %.1f dB\n',SNR);
fprintf('ISI strength         : %.0f %%\n',alphaPercent);
fprintf('ISI delay            : %.2f Tb\n', ...
    isiDelay/samplesPerSymbol);
fprintf('Number of eye traces : %d\n',numberOfTraces);

fprintf('============================================\n');


%% 4. POLAR NRZ MAPPING

% 0 -> -1
% 1 -> +1

symbols = 2*bits - 1;


%% 5. BASEBAND SIGNAL

txSignal = repelem(symbols,samplesPerSymbol);


%% 6. TIME AXIS

Ts = 1/Fs;

t = (0:length(txSignal)-1)*Ts;


%% 7. IDEAL SIGNAL

idealSignal = txSignal;


%% 8. AWGN

awgnSignal = awgn(txSignal,SNR,'measured');


%% 9. ISI CHANNEL

h = zeros(1,isiDelay+1);

h(1) = 1-alpha;
h(isiDelay+1) = alpha;

isiSignal = conv(txSignal,h,'same');


%% 10. AWGN + ISI

combinedSignal = awgn(isiSignal,SNR,'measured');


%% 11. TIME-DOMAIN SIGNAL COMPARISON

samplesToPlot = min(10*samplesPerSymbol,length(txSignal));

figure('Name','Digital Signal Comparison');

tiledlayout(4,1);

sgtitle('Digital Signal Distortion Analysis');

% Ideal
nexttile;
plot(t(1:samplesToPlot), ...
    idealSignal(1:samplesToPlot), ...
    'LineWidth',1.5);
grid on;
ylim([-1.5 1.5]);
title('1. Ideal Signal');
ylabel('Amplitude');

% AWGN
nexttile;
plot(t(1:samplesToPlot), ...
    awgnSignal(1:samplesToPlot), ...
    'LineWidth',1.2);
grid on;
ylim([-2 2]);
title(['2. Signal with AWGN (SNR = ', ...
    num2str(SNR),' dB)']);
ylabel('Amplitude');

% ISI
nexttile;
plot(t(1:samplesToPlot), ...
    isiSignal(1:samplesToPlot), ...
    'LineWidth',1.5);
grid on;
ylim([-1.5 1.5]);
title(['3. Signal with ISI (', ...
    num2str(alphaPercent),'%)']);
ylabel('Amplitude');

% AWGN + ISI
nexttile;
plot(t(1:samplesToPlot), ...
    combinedSignal(1:samplesToPlot), ...
    'LineWidth',1.2);
grid on;
ylim([-2 2]);
title('4. Signal with AWGN + ISI');
xlabel('Time (s)');
ylabel('Amplitude');


%% 12. EYE DIAGRAM PARAMETERS

eyeSamples = 2*samplesPerSymbol;

eyeTime = (0:eyeSamples-1)/samplesPerSymbol;

signals = {idealSignal, ...
           awgnSignal, ...
           isiSignal, ...
           combinedSignal};

names = {'Ideal','AWGN','ISI','AWGN + ISI'};


%% 13. EXTRACT 5 EYE TRACES

eyeData = cell(1,4);

for s = 1:4

    currentSignal = signals{s};

    traces = zeros(numberOfTraces,eyeSamples);

    for k = 1:numberOfTraces

        startIndex = (k-1)*samplesPerSymbol + 1;

        traces(k,:) = currentSignal( ...
            startIndex:startIndex+eyeSamples-1);

    end

    eyeData{s} = traces;

end


%% 14. CALCULATE EYE HEIGHT AND WIDTH

eyeHeight = zeros(1,4);
eyeWidth = zeros(1,4);

% Centre of the 2-symbol eye
centerIndex = samplesPerSymbol + 1;

centerTime = eyeTime(centerIndex);

for s = 1:4

    traces = eyeData{s};

    % Upper and lower limits
    upper = max(traces,[],1);
    lower = min(traces,[],1);

    % Eye opening
    opening = upper-lower;

    % Eye height at sampling point
    eyeHeight(s) = opening(centerIndex);

    % Eye width calculation
    maximumOpening = max(opening);

    threshold = 0.90*maximumOpening;

    valid = opening >= threshold;

    left = centerIndex;
    right = centerIndex;

    while left > 1 && valid(left-1)
        left = left-1;
    end

    while right < eyeSamples && valid(right+1)
        right = right+1;
    end

    eyeWidth(s) = ...
        (right-left)/samplesPerSymbol;

end


%% 15. DISPLAY EYE MEASUREMENTS

fprintf('\n============================================\n');
fprintf(' EYE DIAGRAM MEASUREMENTS\n');
fprintf('============================================\n');

for s = 1:4

    fprintf('%-12s : Eye Height = %.3f   Eye Width = %.3f Tb\n', ...
        names{s}, ...
        eyeHeight(s), ...
        eyeWidth(s));

end

fprintf('============================================\n');


%% 16. EYE DIAGRAM

figure('Name','Eye Diagram Analysis');

tiledlayout(2,2);

sgtitle('Eye Diagram Analysis');


% Single simple colour for all traces
traceColour = [0.00 0.45 0.70];


for s = 1:4

    nexttile;

    traces = eyeData{s};

    hold on;


    % Plot 5 superimposed traces
    for k = 1:numberOfTraces

        plot(eyeTime, ...
            traces(k,:), ...
            'Color',traceColour, ...
            'LineWidth',1.4);

    end


    % Upper and lower values
    upper = max(traces,[],1);
    lower = min(traces,[],1);

    upperValue = upper(centerIndex);
    lowerValue = lower(centerIndex);


    % Eye-height markers
    plot(centerTime, ...
        upperValue, ...
        'ko', ...
        'MarkerFaceColor','k');

    plot(centerTime, ...
        lowerValue, ...
        'ko', ...
        'MarkerFaceColor','k');


    % Eye-height line
    plot([centerTime centerTime], ...
        [lowerValue upperValue], ...
        'k--', ...
        'LineWidth',1.3);


    % Sampling point
    xline(centerTime, ...
        'k--', ...
        'Sampling Point');


    grid on;

    xlim([0 1.8]);


    if s == 1 || s == 3

        ylim([-1.3 1.3]);

    else

        ylim([-2 2]);

    end


    title({names{s}, ...
        sprintf('Eye Height = %.3f',eyeHeight(s)), ...
        sprintf('Eye Width = %.3f T_b',eyeWidth(s))});


    xlabel('Time / Symbol Period');
    ylabel('Amplitude');

    legend off;

    hold off;

end