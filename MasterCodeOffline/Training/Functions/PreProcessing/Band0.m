function y = Band0(x)
%BAND0 Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 20-Mar-2018 13:55:15

%#codegen

% To generate C/C++ code from this function use the codegen command. Type
% 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    % % Generalized REMEZ FIR Lowpass filter designed using the FIRGR function.
    %
    % % All frequency values are in Hz.
    % Fs = 256;  % Sampling Frequency
    %
    % Fpass = 1;                 % Passband Frequency
    % Fstop = 2;                 % Stopband Frequency
    % Dpass = 0.00057564620966;  % Passband Ripple
    % Dstop = 0.0001;            % Stopband Attenuation
    % dens  = 20;                % Density Factor
    %
    % % Calculate the coefficients using the FIRGR function.
    % b  = firgr('minorder', [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Dpass ...
    %            Dstop], {dens});
    
    Hd = dsp.FIRFilter( ...
        'Numerator', [-5.37084731419373e-05 -7.7832699021744e-06 ...
        -8.333822862339e-06 -8.90075388533843e-06 -9.48359857969911e-06 ...
        -1.00818577441373e-05 -1.06950002829756e-05 -1.13224972531379e-05 ...
        -1.19636872739564e-05 -1.26178432375719e-05 -1.32841718152636e-05 ...
        -1.39618547975934e-05 -1.46499968670122e-05 -1.53477177890794e-05 ...
        -1.6054147579621e-05 -1.67681774123156e-05 -1.74885609873609e-05 ...
        -1.82141441993702e-05 -1.89436946747648e-05 -1.96759152048105e-05 ...
        -2.04096358647652e-05 -2.11435372980588e-05 -2.18761186020345e-05 ...
        -2.26059713448864e-05 -2.33312013832371e-05 -2.40503915009749e-05 ...
        -2.47617996008223e-05 -2.54641741705281e-05 -2.6155668639282e-05 ...
        -2.68344797177217e-05 -2.74987159793839e-05 -2.81463014864577e-05 ...
        -2.87758319166552e-05 -2.93854212653874e-05 -2.9973012254657e-05 ...
        -3.05365123508743e-05 -3.10736758107918e-05 -3.15826383782207e-05 ...
        -3.20618732169332e-05 -3.25092959971539e-05 -3.29222592909973e-05 ...
        -3.32985018325579e-05 -3.36364569313932e-05 -3.39344477528839e-05 ...
        -3.41898985423919e-05 -3.44000519682221e-05 -3.45633678028359e-05 ...
        -3.46786201022791e-05 -3.47428886891656e-05 -3.47532971410597e-05 ...
        -3.47097491670694e-05 -3.46099838607234e-05 -3.44495957743511e-05 ...
        -3.42308735254522e-05 -3.39481552448419e-05 -3.36022096627979e-05 ...
        -3.31900304362261e-05 -3.27105795948673e-05 -3.21621260294038e-05 ...
        -3.154316019075e-05 -3.08522539865518e-05 -3.00881494895434e-05 ...
        -2.92497081455813e-05 -2.83357034017089e-05 -2.73450043837884e-05 ...
        -2.62766857421283e-05 -2.51299202420203e-05 -2.39040204150956e-05 ...
        -2.25983711582832e-05 -2.12123375289705e-05 -1.97455048723717e-05 ...
        -1.81977246199125e-05 -1.65688873378698e-05 -1.48590068343304e-05 ...
        -1.30681973136414e-05 -1.11965911061437e-05 -9.24489178914465e-06 ...
        -7.21340279701687e-06 -5.10351360189983e-06 -2.915156879504e-06 ...
        -6.50374295476925e-07 1.69031291451231e-06 4.10506209626247e-06 ...
        6.59198222153188e-06 9.15003517270923e-06 1.1776916158624e-05 ...
        1.44701607046134e-05 1.72278318020174e-05 2.00475560602728e-05 ...
        2.29264273159229e-05 2.58616384308567e-05 2.8850364246181e-05 ...
        3.1889434504861e-05 3.49754000267316e-05 3.81047281155503e-05 ...
        4.1273921254195e-05 4.4479218533389e-05 4.77163312889632e-05 ...
        5.09810685196714e-05 5.42695527896463e-05 5.75771568549088e-05 ...
        6.08987051142927e-05 6.42299211761207e-05 6.75657656324827e-05 ...
        7.09008219923832e-05 7.42303741849669e-05 7.75481176485044e-05 ...
        8.08492185387892e-05 8.41275849097708e-05 8.7377723259999e-05 ...
        9.05934372743811e-05 9.37687261588453e-05 9.68974544246135e-05 ...
        9.99734784779217e-05 0.000102990630916764 0.000105942487757056 ...
        0.00010882258267858 0.00011162455888416 0.000114342022821779 ...
        0.000116968560369728 0.000119497709988929 0.000121922870790285 ...
        0.000124237510124574 0.000126435225274371 0.00012850951451178 ...
        0.000130453827062015 0.000132261621874285 0.000133926400481181 ...
        0.000135441988491741 0.000136801203614504 0.000137999816618094 ...
        0.00013902756644918 0.000139884498049535 0.000140558639159717 ...
        0.000141047136946939 0.000141345736886439 0.000141446535927018 ...
        0.000141344640288499 0.000141036756352086 0.000140517885718175 ...
        0.000139782338841598 0.000138825885571547 0.000137645377630209 ...
        0.000136237254994861 0.000134597220176192 0.000132721243944581 ...
        0.000130606364001461 0.000128250132006021 0.000125649873515824 ...
        0.000122802983549845 0.000119707312460658 0.000116361223024531 ...
        0.000112763960990642 0.000108915401237328 0.000104815185175375 ...
        0.000100463620278836 9.58611328607576e-05 9.10087058356799e-05 ...
        8.59079085719656e-05 8.05602019731531e-05 7.49674522541979e-05 ...
        6.91312752518258e-05 6.30540389586791e-05 5.67382974262652e-05 ...
        5.01876120704862e-05 4.34064500457677e-05 3.64001106811485e-05 ...
        2.91748537481377e-05 2.17374177333929e-05 1.40945580567412e-05 ...
        6.25291561924801e-06 -1.78139013909764e-06 -1.0002949605312e-05 ...
        -1.84063836072646e-05 -2.69851858970604e-05 -3.57303241107364e-05 ...
        -4.4629110011085e-05 -5.36658486748002e-05 -6.28254956417575e-05 ...
        -7.21002602208434e-05 -8.14945039108432e-05 -9.10166728319057e-05 ...
        -0.000100640361232637 -0.00011024577508582 -0.000120014155919586 ...
        -0.000129788944923247 -0.000139610907617609 -0.000149456996349971 ...
        -0.000159313773553869 -0.000169167079789205 -0.000179002364807469 ...
        -0.000188804798776802 -0.000198559229430793 -0.000208250265184352 ...
        -0.000217862319551373 -0.000227379734044064 -0.000236786647800608 ...
        -0.000246066850307183 -0.000255204001464366 -0.000264181659346831 ...
        -0.000272983136823179 -0.000281591749035135 -0.000289990913395852 ...
        -0.000298163928449147 -0.000306094113736928 -0.000313764769199117 ...
        -0.000321158903038904 -0.000328260077750484 -0.00033505159041669 ...
        -0.000341517415959504 -0.000347640891227887 -0.00035340598352106 ...
        -0.000358796487648269 -0.000363796673281253 -0.000368391553769971 ...
        -0.000372565728712235 -0.000376304324959336 -0.000379592668406168 ...
        -0.00038241640878903 -0.000384762129292674 -0.000386616767905092 ...
        -0.000387967026859405 -0.000388800107271223 -0.0003891043703511 ...
        -0.000388868887351163 -0.000388082755760252 -0.000386735259967279 ...
        -0.000384816848414728 -0.000382319253214678 -0.000379234113022104 ...
        -0.000375552997189768 -0.000371269467082029 -0.00036637839684353 ...
        -0.000360872996194454 -0.000354748657461804 -0.000348003700452682 ...
        -0.000340632066927719 -0.000332634459844812 -0.0003240078473744 ...
        -0.000314752970051734 -0.000304869925598197 -0.000294360305170026 ...
        -0.000283226542938462 -0.000271472136555016 -0.00025910148536997 ...
        -0.000246119813661419 -0.000232533444200261 -0.000218349770048989 ...
        -0.000203577181017293 -0.000188225110484935 -0.000172303900115054 ...
        -0.000155824849976781 -0.000138800450603972 -0.000121244239149066 ...
        -0.00010317065932296 -8.45951813568308e-05 -6.5534211441179e-05 ...
        -4.60051976480432e-05 -2.60268429067752e-05 -5.61844783315602e-06 ...
        1.51990793406873e-05 3.64051956019649e-05 5.79762634862188e-05 ...
        7.98901237462895e-05 0.000102121362774351 0.000124645178715691 ...
        0.000147435981016031 0.000170465901424699 0.000193707290017589 ...
        0.000217131901451497 0.000240709926148601 0.000264410947559833 ...
        0.000288204277314307 0.000312058275557 0.000335940377024652 ...
        0.000359817559115563 0.000383656394058787 0.000407422810754961 ...
        0.000431081902333654 0.000454598287357247 0.000477936616938496 ...
        0.0005010610121228 0.000523934555644027 0.000546520372295203 ...
        0.000568781937356897 0.000590681636655753 0.000612182080764701 ...
        0.000633245820870078 0.000653834613823539 0.000673911559499619 ...
        0.000693438527520418 0.000712378345283134 0.000730693210024695 ...
        0.000748346048347869 0.000765299852630196 0.000781518065072664 ...
        0.000796964389697568 0.000811602731895553 0.000825397586425275 ...
        0.000838314056213531 0.000850317776996542 0.000861375038235948 ...
        0.000871452732878696 0.000880518443680099 0.000888540750534663 ...
        0.000895489176122103 0.000901334072456888 0.000906046814404759 ...
        0.000909599848589563 0.000911966754518715 0.000913122259749995 ...
        0.000913041921791139 0.000911704083039286 0.000909083773908506 ...
        0.000905167841034814 0.000899926882331897 0.000893353337537236 ...
        0.000885427669900645 0.000876132691703742 0.000865459196291774 ...
        0.000853397328306527 0.000839935734699426 0.000825066033113246 ...
        0.000808783850680735 0.000791086380513848 0.000771971048652788 ...
        0.000751436516200307 0.000729484190364969 0.00070611834130978 ...
        0.000681345032729399 0.000655171699013428 0.000627607621995873 ...
        0.000598664251841677 0.000568355522761574 0.000536698032587869 ...
        0.000503710268451012 0.00046941215961788 0.000433825768470527 ...
        0.000396974719565147 0.000358885228675483 0.000319585787489015 ...
        0.000279107163879796 0.000237482579384497 0.000194747190655289 ...
        0.000150938574638211 0.000106095797098433 6.02601513949526e-05 ...
        1.34745204978422e-05 -3.42163137296391e-05 -8.27653364891311e-05 ...
        -0.000132123371600998 -0.000182238736407921 -0.000233057207050493 ...
        -0.000284522860570919 -0.000336578802713111 -0.000389167351467364 ...
        -0.000442229652540789 -0.000495704312313848 -0.000549525991558849 ...
        -0.000603625994636652 -0.000657935506881728 -0.00071238912487527 ...
        -0.000766922944942944 -0.00082146504233861 -0.000875929961726088 ...
        -0.000930241591386346 -0.0009843600876665 -0.00103816122145355 ...
        -0.00109160094663398 -0.00114458696414772 -0.00119704376168609 ...
        -0.00124889096556432 -0.00130004803611502 -0.00135043374997027 ...
        -0.00139996620744393 -0.0014485630358905 -0.00149614152946301 ...
        -0.0015426188075967 -0.00158791175372767 -0.00163193713893596 ...
        -0.00167461186720928 -0.00171585287243558 -0.00175557717126269 ...
        -0.00179370221511525 -0.00183014590168636 -0.00186482656183695 ...
        -0.00189766316874175 -0.00192857521372835 -0.00195748287067509 ...
        -0.00198430762376409 -0.00200897164955292 -0.00203139872723711 ...
        -0.00205151300399128 -0.00206924065596597 -0.00208450856279615 ...
        -0.002097245811418 -0.00210738300471189 -0.00211485183319446 ...
        -0.00211958625465487 -0.00212152170406659 -0.00212059584632443 ...
        -0.00211674886236806 -0.00210992257334852 -0.0021000606591237 ...
        -0.0020871096482783 -0.00207101884624693 -0.00205173971211892 ...
        -0.00202922588835101 -0.00200343384094791 -0.00197432328068604 ...
        -0.00194185658380596 -0.00190599828055453 -0.00186671616704715 ...
        -0.0018239819523978 -0.00177776960473282 -0.00172805536706979 ...
        -0.00167482072051569 -0.00161804955228476 -0.0015577271043292 ...
        -0.00149384605083687 -0.00142639812687577 -0.00135538188524121 ...
        -0.00128079706466909 -0.00120264810309251 -0.00112094258508701 ...
        -0.00103569181967717 -0.000946910527080521 -0.000854616959395865 ...
        -0.00075883313268258 -0.000659584679412818 -0.000556900853489859 ...
        -0.0004508145215511 -0.00034136204514664 -0.000228583466507846 ...
        -0.000112522594895201 6.77324138975975e-06 0.000129253207282955 ...
        0.000254862899704188 0.000383544446549965 0.000515236348255355 ...
        0.000649873566592683 0.000787387914851382 0.000927707498474401 ...
        0.00107075794651294 0.00121645980098319 0.00136473302402803 ...
        0.0015154912371596 0.00166864810107812 0.00182411246462025 ...
        0.00198178976281475 0.00214158425181695 0.00230339638857075 ...
        0.00246712342899303 0.00263266084084489 0.00279990154789337 ...
        0.00296873540150589 0.00313905002579785 0.00331073119441914 ...
        0.00348366243771787 0.00365772489666866 0.00383279770783816 ...
        0.00400875857487894 0.0041854836604782 0.00436284695095445 ...
        0.00454072074110177 0.0047189766460489 0.00489748501011812 ...
        0.00507611439058538 0.00525473290228971 0.00543320734413638 ...
        0.00561140382909227 0.0057891886222442 0.00596642640018194 ...
        0.00614298236786811 0.0063187206898362 0.00649350619237298 ...
        0.00666720340641282 0.00683967728124109 0.00701079281735114 ...
        0.00718041536692582 0.00734841106141663 0.00751464674874306 ...
        0.00767899011972815 0.00784130986913535 0.00800147568876321 ...
        0.00815935857721524 0.00831483111680972 0.00846776736826497 ...
        0.00861804298057075 0.00876553545394703 0.00891012416237031 ...
        0.00905169047430113 0.0091901178473776 0.00932529202357858 ...
        0.00945710162746877 0.00958543545331641 0.00971019302730809 ...
        0.0098312567078144 0.0099485455615614 0.0100619443338969 ...
        0.0101713622253503 0.010276713814761 0.0103779072736547 ...
        0.0104748538104133 0.0105674728557392 0.0106556887306996 ...
        0.0107394270050915 0.0108186150484087 0.0108931844917926 ...
        0.0109630724917429 0.0110282209191784 0.0110885750340973 ...
        0.0111440832462358 0.0111946975337765 0.011240373965677 ...
        0.0112810734113032 0.0113167615877243 0.011347408357103 ...
        0.0113729876958632 0.0113934778779865 0.0114088609846677 ...
        0.0114191238896877 0.0114242575518798 0.0114242575518798 ...
        0.0114191238896877 0.0114088609846677 0.0113934778779865 ...
        0.0113729876958632 0.011347408357103 0.0113167615877243 ...
        0.0112810734113032 0.011240373965677 0.0111946975337765 ...
        0.0111440832462358 0.0110885750340973 0.0110282209191784 ...
        0.0109630724917429 0.0108931844917926 0.0108186150484087 ...
        0.0107394270050915 0.0106556887306996 0.0105674728557392 ...
        0.0104748538104133 0.0103779072736547 0.010276713814761 ...
        0.0101713622253503 0.0100619443338969 0.0099485455615614 ...
        0.0098312567078144 0.00971019302730809 0.00958543545331641 ...
        0.00945710162746877 0.00932529202357858 0.0091901178473776 ...
        0.00905169047430113 0.00891012416237031 0.00876553545394703 ...
        0.00861804298057075 0.00846776736826497 0.00831483111680972 ...
        0.00815935857721524 0.00800147568876321 0.00784130986913535 ...
        0.00767899011972815 0.00751464674874306 0.00734841106141663 ...
        0.00718041536692582 0.00701079281735114 0.00683967728124109 ...
        0.00666720340641282 0.00649350619237298 0.0063187206898362 ...
        0.00614298236786811 0.00596642640018194 0.0057891886222442 ...
        0.00561140382909227 0.00543320734413638 0.00525473290228971 ...
        0.00507611439058538 0.00489748501011812 0.0047189766460489 ...
        0.00454072074110177 0.00436284695095445 0.0041854836604782 ...
        0.00400875857487894 0.00383279770783816 0.00365772489666866 ...
        0.00348366243771787 0.00331073119441914 0.00313905002579785 ...
        0.00296873540150589 0.00279990154789337 0.00263266084084489 ...
        0.00246712342899303 0.00230339638857075 0.00214158425181695 ...
        0.00198178976281475 0.00182411246462025 0.00166864810107812 ...
        0.0015154912371596 0.00136473302402803 0.00121645980098319 ...
        0.00107075794651294 0.000927707498474401 0.000787387914851382 ...
        0.000649873566592683 0.000515236348255355 0.000383544446549965 ...
        0.000254862899704188 0.000129253207282955 6.77324138975975e-06 ...
        -0.000112522594895201 -0.000228583466507846 -0.00034136204514664 ...
        -0.0004508145215511 -0.000556900853489859 -0.000659584679412818 ...
        -0.00075883313268258 -0.000854616959395865 -0.000946910527080521 ...
        -0.00103569181967717 -0.00112094258508701 -0.00120264810309251 ...
        -0.00128079706466909 -0.00135538188524121 -0.00142639812687577 ...
        -0.00149384605083687 -0.0015577271043292 -0.00161804955228476 ...
        -0.00167482072051569 -0.00172805536706979 -0.00177776960473282 ...
        -0.0018239819523978 -0.00186671616704715 -0.00190599828055453 ...
        -0.00194185658380596 -0.00197432328068604 -0.00200343384094791 ...
        -0.00202922588835101 -0.00205173971211892 -0.00207101884624693 ...
        -0.0020871096482783 -0.0021000606591237 -0.00210992257334852 ...
        -0.00211674886236806 -0.00212059584632443 -0.00212152170406659 ...
        -0.00211958625465487 -0.00211485183319446 -0.00210738300471189 ...
        -0.002097245811418 -0.00208450856279615 -0.00206924065596597 ...
        -0.00205151300399128 -0.00203139872723711 -0.00200897164955292 ...
        -0.00198430762376409 -0.00195748287067509 -0.00192857521372835 ...
        -0.00189766316874175 -0.00186482656183695 -0.00183014590168636 ...
        -0.00179370221511525 -0.00175557717126269 -0.00171585287243558 ...
        -0.00167461186720928 -0.00163193713893596 -0.00158791175372767 ...
        -0.0015426188075967 -0.00149614152946301 -0.0014485630358905 ...
        -0.00139996620744393 -0.00135043374997027 -0.00130004803611502 ...
        -0.00124889096556432 -0.00119704376168609 -0.00114458696414772 ...
        -0.00109160094663398 -0.00103816122145355 -0.0009843600876665 ...
        -0.000930241591386346 -0.000875929961726088 -0.00082146504233861 ...
        -0.000766922944942944 -0.00071238912487527 -0.000657935506881728 ...
        -0.000603625994636652 -0.000549525991558849 -0.000495704312313848 ...
        -0.000442229652540789 -0.000389167351467364 -0.000336578802713111 ...
        -0.000284522860570919 -0.000233057207050493 -0.000182238736407921 ...
        -0.000132123371600998 -8.27653364891311e-05 -3.42163137296391e-05 ...
        1.34745204978422e-05 6.02601513949526e-05 0.000106095797098433 ...
        0.000150938574638211 0.000194747190655289 0.000237482579384497 ...
        0.000279107163879796 0.000319585787489015 0.000358885228675483 ...
        0.000396974719565147 0.000433825768470527 0.00046941215961788 ...
        0.000503710268451012 0.000536698032587869 0.000568355522761574 ...
        0.000598664251841677 0.000627607621995873 0.000655171699013428 ...
        0.000681345032729399 0.00070611834130978 0.000729484190364969 ...
        0.000751436516200307 0.000771971048652788 0.000791086380513848 ...
        0.000808783850680735 0.000825066033113246 0.000839935734699426 ...
        0.000853397328306527 0.000865459196291774 0.000876132691703742 ...
        0.000885427669900645 0.000893353337537236 0.000899926882331897 ...
        0.000905167841034814 0.000909083773908506 0.000911704083039286 ...
        0.000913041921791139 0.000913122259749995 0.000911966754518715 ...
        0.000909599848589563 0.000906046814404759 0.000901334072456888 ...
        0.000895489176122103 0.000888540750534663 0.000880518443680099 ...
        0.000871452732878696 0.000861375038235948 0.000850317776996542 ...
        0.000838314056213531 0.000825397586425275 0.000811602731895553 ...
        0.000796964389697568 0.000781518065072664 0.000765299852630196 ...
        0.000748346048347869 0.000730693210024695 0.000712378345283134 ...
        0.000693438527520418 0.000673911559499619 0.000653834613823539 ...
        0.000633245820870078 0.000612182080764701 0.000590681636655753 ...
        0.000568781937356897 0.000546520372295203 0.000523934555644027 ...
        0.0005010610121228 0.000477936616938496 0.000454598287357247 ...
        0.000431081902333654 0.000407422810754961 0.000383656394058787 ...
        0.000359817559115563 0.000335940377024652 0.000312058275557 ...
        0.000288204277314307 0.000264410947559833 0.000240709926148601 ...
        0.000217131901451497 0.000193707290017589 0.000170465901424699 ...
        0.000147435981016031 0.000124645178715691 0.000102121362774351 ...
        7.98901237462895e-05 5.79762634862188e-05 3.64051956019649e-05 ...
        1.51990793406873e-05 -5.61844783315602e-06 -2.60268429067752e-05 ...
        -4.60051976480432e-05 -6.5534211441179e-05 -8.45951813568308e-05 ...
        -0.00010317065932296 -0.000121244239149066 -0.000138800450603972 ...
        -0.000155824849976781 -0.000172303900115054 -0.000188225110484935 ...
        -0.000203577181017293 -0.000218349770048989 -0.000232533444200261 ...
        -0.000246119813661419 -0.00025910148536997 -0.000271472136555016 ...
        -0.000283226542938462 -0.000294360305170026 -0.000304869925598197 ...
        -0.000314752970051734 -0.0003240078473744 -0.000332634459844812 ...
        -0.000340632066927719 -0.000348003700452682 -0.000354748657461804 ...
        -0.000360872996194454 -0.00036637839684353 -0.000371269467082029 ...
        -0.000375552997189768 -0.000379234113022104 -0.000382319253214678 ...
        -0.000384816848414728 -0.000386735259967279 -0.000388082755760252 ...
        -0.000388868887351163 -0.0003891043703511 -0.000388800107271223 ...
        -0.000387967026859405 -0.000386616767905092 -0.000384762129292674 ...
        -0.00038241640878903 -0.000379592668406168 -0.000376304324959336 ...
        -0.000372565728712235 -0.000368391553769971 -0.000363796673281253 ...
        -0.000358796487648269 -0.00035340598352106 -0.000347640891227887 ...
        -0.000341517415959504 -0.00033505159041669 -0.000328260077750484 ...
        -0.000321158903038904 -0.000313764769199117 -0.000306094113736928 ...
        -0.000298163928449147 -0.000289990913395852 -0.000281591749035135 ...
        -0.000272983136823179 -0.000264181659346831 -0.000255204001464366 ...
        -0.000246066850307183 -0.000236786647800608 -0.000227379734044064 ...
        -0.000217862319551373 -0.000208250265184352 -0.000198559229430793 ...
        -0.000188804798776802 -0.000179002364807469 -0.000169167079789205 ...
        -0.000159313773553869 -0.000149456996349971 -0.000139610907617609 ...
        -0.000129788944923247 -0.000120014155919586 -0.00011024577508582 ...
        -0.000100640361232637 -9.10166728319057e-05 -8.14945039108432e-05 ...
        -7.21002602208434e-05 -6.28254956417575e-05 -5.36658486748002e-05 ...
        -4.4629110011085e-05 -3.57303241107364e-05 -2.69851858970604e-05 ...
        -1.84063836072646e-05 -1.0002949605312e-05 -1.78139013909764e-06 ...
        6.25291561924801e-06 1.40945580567412e-05 2.17374177333929e-05 ...
        2.91748537481377e-05 3.64001106811485e-05 4.34064500457677e-05 ...
        5.01876120704862e-05 5.67382974262652e-05 6.30540389586791e-05 ...
        6.91312752518258e-05 7.49674522541979e-05 8.05602019731531e-05 ...
        8.59079085719656e-05 9.10087058356799e-05 9.58611328607576e-05 ...
        0.000100463620278836 0.000104815185175375 0.000108915401237328 ...
        0.000112763960990642 0.000116361223024531 0.000119707312460658 ...
        0.000122802983549845 0.000125649873515824 0.000128250132006021 ...
        0.000130606364001461 0.000132721243944581 0.000134597220176192 ...
        0.000136237254994861 0.000137645377630209 0.000138825885571547 ...
        0.000139782338841598 0.000140517885718175 0.000141036756352086 ...
        0.000141344640288499 0.000141446535927018 0.000141345736886439 ...
        0.000141047136946939 0.000140558639159717 0.000139884498049535 ...
        0.00013902756644918 0.000137999816618094 0.000136801203614504 ...
        0.000135441988491741 0.000133926400481181 0.000132261621874285 ...
        0.000130453827062015 0.00012850951451178 0.000126435225274371 ...
        0.000124237510124574 0.000121922870790285 0.000119497709988929 ...
        0.000116968560369728 0.000114342022821779 0.00011162455888416 ...
        0.00010882258267858 0.000105942487757056 0.000102990630916764 ...
        9.99734784779217e-05 9.68974544246135e-05 9.37687261588453e-05 ...
        9.05934372743811e-05 8.7377723259999e-05 8.41275849097708e-05 ...
        8.08492185387892e-05 7.75481176485044e-05 7.42303741849669e-05 ...
        7.09008219923832e-05 6.75657656324827e-05 6.42299211761207e-05 ...
        6.08987051142927e-05 5.75771568549088e-05 5.42695527896463e-05 ...
        5.09810685196714e-05 4.77163312889632e-05 4.4479218533389e-05 ...
        4.1273921254195e-05 3.81047281155503e-05 3.49754000267316e-05 ...
        3.1889434504861e-05 2.8850364246181e-05 2.58616384308567e-05 ...
        2.29264273159229e-05 2.00475560602728e-05 1.72278318020174e-05 ...
        1.44701607046134e-05 1.1776916158624e-05 9.15003517270923e-06 ...
        6.59198222153188e-06 4.10506209626247e-06 1.69031291451231e-06 ...
        -6.50374295476925e-07 -2.915156879504e-06 -5.10351360189983e-06 ...
        -7.21340279701687e-06 -9.24489178914465e-06 -1.11965911061437e-05 ...
        -1.30681973136414e-05 -1.48590068343304e-05 -1.65688873378698e-05 ...
        -1.81977246199125e-05 -1.97455048723717e-05 -2.12123375289705e-05 ...
        -2.25983711582832e-05 -2.39040204150956e-05 -2.51299202420203e-05 ...
        -2.62766857421283e-05 -2.73450043837884e-05 -2.83357034017089e-05 ...
        -2.92497081455813e-05 -3.00881494895434e-05 -3.08522539865518e-05 ...
        -3.154316019075e-05 -3.21621260294038e-05 -3.27105795948673e-05 ...
        -3.31900304362261e-05 -3.36022096627979e-05 -3.39481552448419e-05 ...
        -3.42308735254522e-05 -3.44495957743511e-05 -3.46099838607234e-05 ...
        -3.47097491670694e-05 -3.47532971410597e-05 -3.47428886891656e-05 ...
        -3.46786201022791e-05 -3.45633678028359e-05 -3.44000519682221e-05 ...
        -3.41898985423919e-05 -3.39344477528839e-05 -3.36364569313932e-05 ...
        -3.32985018325579e-05 -3.29222592909973e-05 -3.25092959971539e-05 ...
        -3.20618732169332e-05 -3.15826383782207e-05 -3.10736758107918e-05 ...
        -3.05365123508743e-05 -2.9973012254657e-05 -2.93854212653874e-05 ...
        -2.87758319166552e-05 -2.81463014864577e-05 -2.74987159793839e-05 ...
        -2.68344797177217e-05 -2.6155668639282e-05 -2.54641741705281e-05 ...
        -2.47617996008223e-05 -2.40503915009749e-05 -2.33312013832371e-05 ...
        -2.26059713448864e-05 -2.18761186020345e-05 -2.11435372980588e-05 ...
        -2.04096358647652e-05 -1.96759152048105e-05 -1.89436946747648e-05 ...
        -1.82141441993702e-05 -1.74885609873609e-05 -1.67681774123156e-05 ...
        -1.6054147579621e-05 -1.53477177890794e-05 -1.46499968670122e-05 ...
        -1.39618547975934e-05 -1.32841718152636e-05 -1.26178432375719e-05 ...
        -1.19636872739564e-05 -1.13224972531379e-05 -1.06950002829756e-05 ...
        -1.00818577441373e-05 -9.48359857969911e-06 -8.90075388533843e-06 ...
        -8.333822862339e-06 -7.7832699021744e-06 -5.37084731419373e-05]);
end

y = step(Hd,double(x));


% [EOF]