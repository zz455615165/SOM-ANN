function [Y,Xf,Af] = SOMANN(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 29-Mar-2023 13:47:17.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx39 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx9 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Layer 1
IW1_1 = [226.79681113961882488 217.91068813238703683 213.23903877068451607 214.6686164151259959 230.36621922654268246 239.80680325884992499 255.12795160712693132 254.34261177542438759 249.37479505213144648 256.35839101726219269 249.30066035740091479 254.86639430682808438 259.51186887949438642 262.04111475886190874 262.95543389740691964 196.72753147266686824 189.06275566646360176 232.14918018344454254 243.01474447691353475 253.68104237462603123 252.91859058642899072 249.97908907036972437 245.46063695999274046 237.93208127947045227 226.48169188876164526 219.8561295255835546 213.78243627446050823 215.74735342844195429 221.34204332861358466 229.61990458338078724 239.15026551624683293 248.64020933055724072 -92.903458456347507877 -0.29772247996625794686 9564.5837199493907974 528.9443272880640734 100.87094053142132566 85.151834668916023929 59.058625052720373105;202.05743593688399073 225.15753457305626739 224.43065972284438203 225.03853561681356155 227.51745444481531422 230.23227194689823705 230.36628901630365363 227.71096402789481772 220.06853089638804022 212.56832409779954673 237.67684026595648561 237.89531431285621466 235.95742696359616275 231.48402793254322773 224.79377235622581566 179.39743445099753671 183.19422427764428107 212.41469724618954729 219.73729506304300685 228.53461890047816496 230.9342342923280853 233.24430913699578127 233.89757727325132919 230.04118502894277754 227.31688315797782707 225.73748831215726796 225.88532630090776365 226.14211170270863249 227.03910762523659628 227.75691394076733332 229.45913470371584708 232.30040930203642802 -40.277064220183476095 32.649770642201829673 8940.293577981650742 2043.4380733944958592 2161.0756880733943035 14.548165137614699205 4.1284403669724776265;241.82765458044093521 219.82934174671422056 212.60795011368551855 211.61846602225142533 219.90588945760430306 228.57838967462848245 253.04605264497402572 255.27616438095631679 256.43578056931227138 260.58879926911436087 244.01162490671197247 250.21333702845132052 255.72053345050477446 259.40627865505723548 262.33526317489418034 206.31020018773244828 195.23847203268471162 244.82092660685702867 250.94611299445227814 251.67217857142858861 246.94272447561289141 240.42079162003443571 234.6867774257794963 227.40855104877431359 218.54623348616675571 213.70555089533920068 212.5462614294137893 216.71469659554492182 223.79845897565496671 232.93869089136794059 244.03876312923449632 253.23527490162101117 -77.100530705079592053 3.9773313115996957734 8664.6679302501888742 5687.3866565579974122 173.04473085670960586 88.031842304776318997 66.097043214556464363;228.42194002823865162 217.74496826336539357 212.52519307033634277 213.80930309158429736 229.77108619882051244 239.63372246310004243 256.63816647563908191 256.28096341057641894 252.33600967050460895 259.43969320393301814 249.21338623376203714 255.09775185070452608 260.18095519388322145 263.30613334573428119 265.13710394523133118 194.52237378073729701 186.0720613012566389 234.03399325004284037 244.71421264238614413 254.88701804865627309 253.67871557872751964 250.20333077704503921 245.32172932219697259 237.59978997932608991 225.84580442223602859 219.0548793173794877 213.04300847030717136 215.23028602713068835 221.27716013766359993 230.02502641041937181 240.02757765632736664 249.82450075475330209 -95.202967625899304949 -2.2183902877697816436 9602.8965827338142844 1573.7720323741009452 64.883093525179859284 92.494154676258958148 63.495953237410041936;232.14885650099370196 219.22908618592376229 213.54397302460247943 213.75714129531593244 224.98797269051536318 233.88871292917352207 254.29246451394595852 255.17451942845391955 253.84328257778236093 256.71930151153026145 246.16177628366568797 251.87181774474026952 256.95792058576608952 260.05431950083948323 262.0110740474232216 200.56245808270674047 191.26892226677799158 241.1640744124199216 248.39809167502085074 253.09034404204948032 249.93922072820942049 244.8229919855193657 239.54369559593422423 232.1571593274854024 222.36757858674462796 217.02426930799214233 214.01397988443332565 216.84004465608464329 222.71808608187131995 231.04208054023951036 241.13898962406014448 250.63072019493174025 -84.00280701754383017 0.71052631578948488578 8999.4273684210529609 4197.9192982456143 175.98807017543856546 92.209824561403536336 57.171929824561352973;241.69377812799422145 221.08405846649745286 214.04005142787721638 213.27224518398074338 220.20135876637581873 227.85186371713317044 251.19601571424948361 253.46952989686207047 255.34213690127972995 255.40592825547705047 241.3930479373572382 247.36622599475779793 252.60900693209671886 256.50346250714000007 258.27720709746739658 221.59610943396216953 208.07363999326142334 247.22753990341422536 251.4808140947888262 250.49361206199469621 245.49201438679250487 238.84463036837377103 233.91437343890390821 226.96135650269548023 219.27567866127583329 215.25480161725067774 214.4030232479784388 218.26640134770883606 225.48303090745736199 234.93843177223720886 245.08953836477979848 253.35915832210241661 -105.80764150943397794 0.47783018867924087481 10551.701886792452569 5834.4632075471690769 176.87264150943397567 136.23490566037742155 62.068867924528355218;226.29412428680126368 218.72312643749467043 213.99115028893012891 214.98594003782542927 228.50253162488255043 237.57310586655486873 254.62234549373164327 254.46933601178525919 250.77886455022331802 255.05394122165881754 247.37838293341815188 252.90194890893519641 257.8104844375209268 260.79192539902987846 262.2817774856498545 194.7788814136682447 186.92441305127778151 235.87141333810387778 245.11761789538630296 253.27636806984759232 251.56691012880557423 247.73773325664924982 243.01205939665982214 235.59494254508396693 225.12514606939816986 219.25972189301285198 214.61003848693806617 216.57698190235694824 222.06851865158213855 229.95410618578449657 239.4223539138457113 248.87122861322038148 -92.980824639841046064 0.063686040735217885889 9491.9354197714819747 2574.4545454545459506 81.610531544957794381 91.094883258817745286 55.35221063089912974;232.12651476863234734 218.26895770504225425 211.48234066807117415 211.99617894235737481 226.99764741478404062 237.37461966168669392 258.76774386174702158 259.56316227425548959 258.27199105445595251 264.15072591064284779 247.9588168239147592 254.27131061643154908 259.91344908037109462 263.85701198743510076 266.84399477258563138 193.09737157648629591 180.45298173065705782 239.24133545132599465 248.97317548721781577 256.64279181908790406 254.02104749180904264 248.91680868615532063 243.25366360233698515 235.31222821701604175 223.49918788237849299 216.83459112404702296 211.66471600741166981 214.90274480972524884 222.14055259063101744 231.6838103256778254 242.08492269592088064 251.94161123569892879 -98.992117568470263222 -3.9380093520373966598 9875.7982631930535717 3441.3754175016701993 47.442217768871081773 114.88777555110223716 69.907147628590564636;233.98560211055004743 220.04159861204539084 213.73234062986244908 213.80759692686726225 224.36499285559432337 232.99029736024218096 254.35873817032299371 255.64514624884506588 255.17307645552384088 256.54854861690785128 243.79879808861184642 249.43981425811637109 254.45406383973428888 257.84480912457860313 259.80827506290916062 204.98902566521769586 192.06988111374565165 242.3474385546334986 249.44828185635248019 253.0942353042876789 249.48183881643944915 243.82797980800887672 238.66899663604027637 231.44672754561034367 222.07425082164263586 217.08117481393662729 214.15946684614368678 217.19036000296387101 223.83317344233682888 232.51038328064279881 242.12364600375420309 250.84543776427582884 -100.34929460580910643 1.2559336099585030055 10238.048132780082597 4624.7817427385898554 120.75352697095435417 121.94190871369296758 60.582572614107931486];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

% Dimensions
TS = size(X,2); % timesteps

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    X{1,ts} = X{1,ts}';
    % no processing
    
    % Layer 1
    z1 = negdist_apply(IW1_1,X{1,ts});
    a1 = compet_apply(z1);
    
    % Output 1
    Y{1,ts} = a1;
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(1,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Negative Distance Weight Function
function z = negdist_apply(w,p,~)
[S,R] = size(w);
Q = size(p,2);
if isa(w,'gpuArray')
    z = iNegDistApplyGPU(w,p,R,S,Q);
else
    z = iNegDistApplyCPU(w,p,S,Q);
end
end
function z = iNegDistApplyCPU(w,p,S,Q)
z = zeros(S,Q);
if (Q<S)
    pt = p';
    for q=1:Q
        z(:,q) = sum(bsxfun(@minus,w,pt(q,:)).^2,2);
    end
else
    wt = w';
    for i=1:S
        z(i,:) = sum(bsxfun(@minus,wt(:,i),p).^2,1);
    end
end
z = -sqrt(z);
end
function z = iNegDistApplyGPU(w,p,R,S,Q)
p = reshape(p,1,R,Q);
sd = arrayfun(@iNegDistApplyGPUHelper,w,p);
z = -sqrt(reshape(sum(sd,2),S,Q));
end
function sd = iNegDistApplyGPUHelper(w,p)
sd = (w-p) .^ 2;
end

% Competitive Transfer Function
function a = compet_apply(n,~)
if isempty(n)
    a = n;
else
    [S,Q] = size(n);
    nanInd = any(isnan(n),1);
    a = zeros(S,Q,'like',n);
    [~,maxRows] = max(n,[],1);
    onesInd = maxRows + S*(0:(Q-1));
    a(onesInd) = 1;
    a(:,nanInd) = NaN;
end
end
