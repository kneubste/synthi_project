-------------------------------------------------------------------------------
-- Project     : audio_top
-- Description : Constants and LUT for tone generation with DDS
--
--
-------------------------------------------------------------------------------
--
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 12.04.13 | dqtm     | file created for DTP2 Milestone-3 in FS13
-- 02.04.14 | dqtm     | updated for DTP2 in FS14, cause using new parameters
-- 2020-05-11  1.3      lussimat   Array changs for 10 DDS.
-- 2020-05-16  1.4      kneubste   Addition of instrument-luts.
--                                 Increase of bit-width for new Luts.
-- 2020-05-17  1.5      kneubste   Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in Design of Block dds.vhd and tone_decoder.vhd :
--   use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tone_gen_pkg is

  -------------------------------------------------------------------------------
  -- TYPES AND CONSTANTS FOR MIDI INTERFACE
  -------------------------------------------------------------------------------       
  -- type t_note_record is
  --   record
  --    valid           : std_logic;
  --    number          : std_logic_vector(6 downto 0);
  --    velocity        : std_logic_vector(6 downto 0); 
  --   end record;

  -- CONSTANT NOTE_INIT_VALUE : t_note_record := (valid         => '0',
  --                                                                                     number         => (others => '0'),
  --                                                                                     velocity       => (others => '0'));

  -- type t_midi_array is array (0 to 9) of t_note_record; -- 10x note_record


  -------------------------------------------------------------------------------
  -- CONSTANT DECLARATION FOR SEVERAL BLOCKS (DDS, TONE_GENERATOR, ...)
  -------------------------------------------------------------------------------
  constant N_CUM : natural := 19;  -- number of bits in phase cumulator phicum_reg
  constant N_LUT : natural := 8;        -- number of bits in LUT address
  constant L     : natural := 2**N_LUT;  -- length of LUT

  constant N_RESOL : natural := 16;     -- Attention: 1 bit reserved for sign
  constant N_AUDIO : natural := 16;     -- Audio Paralell Bus width

  constant SEQUENZ : natural := 32;
  constant ARRAY_L : natural := 99;

  -------------------------------------------------------------------------------
  -- TYPE DECLARATION FOR DDS
  -------------------------------------------------------------------------------
  type t_tone_array is array (0 to 9) of std_logic_vector(6 downto 0);
  type note_on_array is array (0 to 9) of std_logic;
  type t_dds_o_array is array (0 to 9) of std_logic_vector(N_AUDIO-1 downto 0);
  type NOTE_VELOCITY_RAM_TYPE is array (0 to (ARRAY_L-1)) of std_logic_vector (6 downto 0);
  type TIMER_RAM_TYPE is array (0 to (ARRAY_L-1)) of std_logic_vector (31 downto 0);

  subtype t_audio_range is integer range -(2**(N_RESOL-1)) to (2**(N_RESOL-1))-1;  -- range : [-2^12; +(2^12)-1]

  type t_lut_rom is array (0 to L-1) of t_audio_range;
  --type t_lut_rom is array (0 to L-1) of integer;

  constant LUT_sinus : t_lut_rom := (
    0, 804, 1608, 2410, 3211, 4010, 4808, 5601, 6394,
    7178, 7962, 8740, 9512, 10279, 11039, 11793, 12540, 13278, 14010,
    14732, 15446, 16150, 16846, 17531, 18204, 18868, 19520, 20159, 20788,
    21403, 22005, 22595, 23170, 23731, 24279, 24811, 25330, 25832, 26319,
    26790, 27246, 27684, 28105, 28510, 28898, 29269, 29620, 29955, 30273,
    30572, 30851, 31113, 31356, 31580, 31785, 31970, 32137, 32285, 32412,
    32520, 32609, 32678, 32727, 32758, 32767, 32757, 32727, 32678, 32609,
    32521, 32413, 32285, 32138, 31970, 31786, 31579, 31355, 31113, 30852,
    30572, 30273, 29956, 29621, 29269, 28897, 28510, 28105, 27683, 27245,
    26790, 26318, 25832, 25328, 24811, 24280, 23732, 23170, 22594, 22005,
    21402, 20787, 20159, 19520, 18868, 18205, 17530, 16845, 16151, 15447,
    14732, 14009, 13279, 12539, 11793, 11039, 10278, 9512, 8740, 7962,
    7179, 6394, 5602, 4808, 4011, 3212, 2410, 1608, 804, 0,
    -803, -1607, -2411, -3212, -4012, -4808, -5602, -6393, -7179, -7962,
    -8739, -9512, -10278, -11039, -11793, -12539, -13279, -14010, -14732, -15447,
    -16151, -16846, -17529, -18205, -18868, -19519, -20160, -20787, -21403, -22005,
    -22595, -23170, -23731, -24279, -24811, -25330, -25832, -26318, -26790, -27244,
    -27683, -28106, -28511, -28898, -29268, -29620, -29956, -30273, -30572, -30851,
    -31113, -31355, -31580, -31785, -31970, -32137, -32285, -32412, -32521, -32609,
    -32678, -32727, -32757, -32767, -32758, -32727, -32678, -32609, -32521, -32413,
    -32285, -32137, -31970, -31785, -31580, -31356, -31113, -30852, -30572, -30273,
    -29956, -29621, -29268, -28898, -28510, -28106, -27683, -27245, -26790, -26319,
    -25832, -25329, -24811, -24279, -23731, -23169, -22595, -22005, -21402, -20787,
    -20159, -19520, -18868, -18204, -17530, -16845, -16151, -15446, -14732, -14010,
    -13279, -12540, -11793, -11038, -10278, -9511, -8740, -7962, -7179, -6393,
    -5602, -4808, -4011, -3212, -2410, -1607, -804);  -- Veraenderter Sinus

  constant LUT_violin_a : t_lut_rom := (
    189, 538, 613, 311, 318, 732, 2362, 5825, 9817,
    13940, 18644, 23337, 27475, 30817, 32588, 32543, 30738, 27870, 24252,
    19980, 15913, 12397, 9484, 7398, 6682, 7388, 9296, 12198, 15452,
    18397, 21122, 23623, 24908, 25262, 25286, 25321, 25366, 25607, 26187,
    26333, 25846, 24578, 22469, 19638, 16323, 12675, 8644, 4581, 730,
    -3550, -7908, -12149, -15640, -17791, -19027, -19633, -19869, -19548, -19100,
    -18712, -18485, -18085, -17738, -17766, -18099, -18827, -19721, -21010, -22539,
    -24128, -25589, -26603, -27024, -26954, -26345, -24988, -23040, -20354, -17200,
    -14059, -11038, -8166, -5523, -3260, -1729, -1028, -947, -1176, -1618,
    -2256, -3002, -3935, -4965, -6321, -7595, -8746, -9780, -10674, -10834,
    -9935, -8204, -5508, -2637, 504, 3796, 6808, 9517, 11729, 13298,
    14221, 14639, 14741, 14619, 14266, 13684, 13045, 12321, 11225, 9992,
    8879, 7685, 6883, 6321, 5998, 6034, 6096, 6064, 5806, 5613,
    5151, 4682, 4358, 4034, 3850, 3800, 3908, 4358, 5112, 6106,
    7165, 8217, 9169, 9719, 9687, 8894, 7538, 5580, 3407, 1457,
    -230, -1563, -1969, -1424, -319, 1289, 2922, 4575, 5996, 6960,
    7299, 7118, 6758, 6226, 5705, 5260, 5238, 5224, 5068, 4892,
    4393, 3652, 2650, 1375, 99, -1047, -1980, -2386, -2242, -1685,
    -966, -238, 422, 681, 509, 112, -557, -1345, -2143, -2980,
    -3631, -4051, -4256, -4066, -3689, -3387, -2885, -2253, -1814, -1493,
    -1159, -941, -722, -401, -146, -191, -274, -155, -271, -402,
    -649, -1188, -1909, -2613, -3629, -4992, -6013, -6563, -6570, -6427,
    -6239, -5927, -5779, -5910, -6189, -6658, -7646, -9167, -11131, -13424,
    -15906, -18151, -19923, -21456, -22398, -22287, -21049, -19091, -16429, -13767,
    -11244, -8863, -7579, -7172, -7529, -8861, -10774, -12406, -13586, -14251,
    -13613, -11739, -9496, -6895, -4481, -2605, -837);

  constant LUT_chello_a : t_lut_rom := (
    -35, 782, 2274, 3066, 4472, 6150, 7266, 7481, 7257,
    6923, 6415, 5629, 4613, 3706, 3071, 3357, 4845, 7561, 10867,
    13533, 15696, 17734, 18669, 18854, 18760, 19617, 21384, 23526, 26659,
    29816, 32208, 32688, 31570, 29928, 28656, 27624, 26016, 24008, 22328,
    21262, 20200, 18822, 17165, 15455, 13811, 12414, 10693, 8444, 5873,
    3071, 280, -2792, -5623, -7743, -8928, -9539, -10819, -12907, -15836,
    -18949, -22558, -25862, -28072, -29296, -29242, -28109, -26819, -26329, -25850,
    -25006, -24355, -24821, -25712, -26449, -26796, -26439, -24847, -22220, -19948,
    -17827, -16254, -16953, -18441, -19776, -20998, -21247, -20823, -19570, -17947,
    -16753, -15783, -14617, -13490, -12596, -11502, -10320, -8987, -7376, -6152,
    -4044, -933, 1629, 2949, 3746, 5104, 6584, 7244, 7912, 8737,
    8883, 8201, 7256, 6692, 5959, 5009, 4549, 4382, 3595, 1956,
    -324, -2383, -3985, -4994, -5574, -5313, -4436, -3778, -4273, -4781,
    -5061, -5427, -5626, -5563, -4619, -2676, -471, 1838, 4501, 5782,
    7078, 6814, 6244, 5924, 5807, 7270, 7392, 8134, 8273, 8760,
    10731, 10974, 11927, 11655, 11740, 12454, 12650, 12791, 13521, 15953,
    17704, 18675, 18065, 19877, 20233, 20099, 20499, 18905, 18099, 16009,
    15291, 13709, 10469, 10044, 9393, 7583, 4070, -252, -2875, -5240,
    -6049, -5359, -3033, -393, 1491, 2121, 2059, 1238, -554, -524,
    -138, 1871, 4813, 7148, 10391, 12053, 11377, 8392, 3827, -340,
    -4231, -7194, -9300, -10242, -11004, -13035, -15760, -18899, -21577, -24165,
    -25513, -25279, -23477, -21512, -19672, -16851, -14505, -12956, -12179, -11460,
    -10221, -9112, -7789, -6138, -4209, -1803, -484, 342, -351, -1657,
    -2348, -2493, -2049, -1083, 1373, 4258, 5907, 5789, 4393, 2931,
    1951, 704, -463, -894, -570, -555, -862, -1605, -2315, -3361,
    -4063, -3853, -3392, -2603, -1718, -891, -227);



  constant LUT_altosax_26 : t_lut_rom := (
    784, 2975, 5320, 7811, 10376, 13002, 15501, 17700, 19612,
    21410, 23072, 24632, 26078, 27481, 28845, 30023, 31079, 31928, 32343,
    32064, 31327, 30492, 29284, 27679, 26192, 24949, 23794, 22775, 21836,
    20878, 19904, 18595, 17092, 15735, 14413, 13084, 11849, 10567, 9020,
    7172, 5053, 2828, 412, -2199, -4891, -7663, -10399, -12967, -15348,
    -17609, -19655, -21388, -23021, -24562, -25734, -26595, -27483, -28516, -29579,
    -30894, -32138, -32709, -32734, -32512, -32074, -31574, -31008, -30191, -29597,
    -29343, -29167, -29254, -29739, -30183, -30277, -30203, -30176, -30192, -30168,
    -30065, -29770, -29321, -28880, -28468, -27962, -27431, -26838, -26149, -25484,
    -24800, -23923, -22849, -21731, -20565, -19179, -17638, -16172, -14615, -12920,
    -11116, -9356, -7752, -6023, -4298, -2725, -1103, 600, 2466, 4306,
    6030, 7843, 9721, 11664, 13577, 15320, 16797, 18150, 19439, 20601,
    21506, 22235, 22957, 23628, 24074, 24466, 24886, 25141, 25261, 25253,
    25032, 24583, 24048, 23310, 22322, 21303, 20246, 18998, 17645, 16180,
    14700, 13268, 11894, 10556, 9209, 7807, 6316, 4778, 3249, 1824,
    573, -518, -1541, -2408, -3114, -3641, -4056, -4486, -4882, -5166,
    -5385, -5535, -5523, -5300, -4973, -4699, -4453, -4076, -3441, -2736,
    -2130, -1494, -790, -68, 613, 1203, 1804, 2441, 3082, 3643,
    4123, 4659, 5235, 5763, 6202, 6502, 6762, 6973, 7007, 6990,
    6918, 6724, 6578, 6471, 6229, 6007, 5896, 5784, 5580, 5316,
    5125, 4936, 4529, 3970, 3469, 2996, 2539, 1991, 1333, 766,
    266, -209, -625, -996, -1299, -1595, -1939, -2279, -2509, -2723,
    -2953, -3147, -3341, -3435, -3353, -3199, -3111, -3030, -2877, -2657,
    -2435, -2281, -2089, -1887, -1853, -1941, -1995, -2021, -2163, -2438,
    -2770, -3198, -3667, -4077, -4550, -5088, -5668, -6158, -6459, -6683,
    -6752, -6527, -6047, -5326, -4309, -2938, -1230);


  constant LUT_squ8bit : t_lut_rom := (
    333, 32767, 30225, 32767, 31600, 32767, 32138, 32767, 32442,
    32767, 32635, 32767, 32763, 32689, 32767, 32607, 32767, 32553, 32767,
    32522, 32767, 32510, 32767, 32511, 32767, 32519, 32767, 32533, 32767,
    32550, 32723, 32567, 32678, 32578, 32634, 32587, 32597, 32589, 32563,
    32586, 32536, 32579, 32512, 32566, 32492, 32550, 32476, 32529, 32463,
    32509, 32450, 32485, 32440, 32464, 32429, 32439, 32416, 32418, 32404,
    32397, 32390, 32376, 32375, 32359, 32359, 32340, 32339, 32324, 32321,
    32310, 32300, 32297, 32278, 32284, 32257, 32272, 32232, 32261, 32211,
    32250, 32188, 32237, 32166, 32222, 32148, 32204, 32133, 32181, 32123,
    32156, 32117, 32124, 32116, 32088, 32122, 32046, 32131, 32001, 32144,
    31952, 32158, 31903, 32172, 31858, 32180, 31818, 32181, 31789, 32170,
    31771, 32142, 31776, 32094, 31803, 32019, 31860, 31909, 31955, 31757,
    32102, 31542, 32326, 31221, 32703, 30668, 32767, 29283, 32767, -337,
    -32767, -30230, -32768, -31605, -32768, -32143, -32767, -32444, -32768, -32638,
    -32768, -32767, -32691, -32768, -32611, -32768, -32556, -32768, -32527, -32768,
    -32513, -32768, -32513, -32768, -32524, -32767, -32538, -32768, -32553, -32728,
    -32570, -32682, -32582, -32638, -32589, -32601, -32593, -32566, -32590, -32538,
    -32582, -32515, -32571, -32496, -32552, -32480, -32534, -32466, -32513, -32455,
    -32489, -32442, -32466, -32433, -32443, -32420, -32421, -32407, -32401, -32393,
    -32379, -32378, -32362, -32362, -32344, -32343, -32327, -32324, -32314, -32304,
    -32300, -32281, -32287, -32259, -32277, -32236, -32265, -32212, -32253, -32192,
    -32240, -32170, -32224, -32152, -32207, -32138, -32185, -32126, -32160, -32121,
    -32129, -32120, -32090, -32126, -32049, -32134, -32005, -32147, -31956, -32162,
    -31907, -32174, -31862, -32183, -31822, -32184, -31793, -32174, -31776, -32146,
    -31779, -32098, -31807, -32021, -31862, -31913, -31958, -31760, -32104, -31545,
    -32330, -31223, -32706, -30671, -32767, -29285, -32768);

  constant LUT_symetric_a : t_lut_rom := (
    545, 3084, 5637, 8179, 10674, 13141, 15566, 17965, 20272,
    22423, 24402, 26257, 27861, 29250, 30442, 31349, 32013, 32474, 32722,
    32745, 32590, 32230, 31819, 31239, 30587, 29866, 29088, 28332, 27489,
    26696, 25815, 25018, 24151, 23291, 22466, 21608, 20821, 19927, 19176,
    18387, 17581, 16778, 15963, 15177, 14379, 13583, 12783, 11948, 11082,
    10226, 9312, 8415, 7492, 6498, 5499, 4531, 3523, 2534, 1537,
    571, -366, -1242, -2086, -2784, -3377, -3849, -4118, -4255, -4157,
    -3845, -3287, -2502, -1466, -201, 1262, 2861, 4691, 6514, 8373,
    10260, 12047, 13821, 15455, 16933, 18293, 19536, 20603, 21544, 22326,
    22981, 23473, 23872, 24147, 24328, 24431, 24421, 24411, 24261, 24009,
    23759, 23452, 23013, 22563, 22082, 21529, 20930, 20256, 19563, 18826,
    18060, 17245, 16431, 15534, 14675, 13774, 12821, 11888, 10910, 9953,
    8957, 7961, 6940, 5941, 4932, 3920, 2878, 1853, 815, -220,
    -1260, -2288, -3324, -4354, -5365, -6366, -7376, -8388, -9384, -10364,
    -11324, -12294, -13219, -14176, -15032, -15924, -16784, -17595, -18393, -19144,
    -19864, -20547, -21195, -21769, -22299, -22750, -23212, -23598, -23867, -24119,
    -24348, -24422, -24428, -24406, -24254, -24050, -23711, -23280, -22719, -22010,
    -21160, -20166, -19028, -17724, -16320, -14779, -13073, -11286, -9470, -7562,
    -5748, -3892, -2153, -622, 769, 1939, 2867, 3554, 4006, 4227,
    4221, 4017, 3677, 3128, 2510, 1733, 876, -30, -977, -1963,
    -2954, -3955, -4947, -5919, -6929, -7894, -8796, -9705, -10598, -11448,
    -12314, -13124, -13924, -14718, -15514, -16305, -17127, -17916, -18740, -19480,
    -20306, -21168, -21958, -22834, -23637, -24540, -25346, -26195, -27037, -27845,
    -28667, -29410, -30194, -30861, -31510, -32003, -32398, -32685, -32755, -32648,
    -32300, -31757, -30994, -29967, -28674, -27212, -25486, -23574, -21527, -19303,
    -16948, -14534, -12095, -9612, -7102, -4543, -2003);

  constant LUT_tannerin_a : t_lut_rom := (
    265, 828, 1546, 2401, 3314, 4241, 5147, 6017, 6853,
    7664, 8460, 9240, 10014, 10777, 11527, 12264, 12985, 13696, 14400,
    15101, 15803, 16501, 17195, 17881, 18552, 19216, 19867, 20500, 21121,
    21724, 22316, 22899, 23468, 24030, 24580, 25117, 25641, 26149, 26640,
    27110, 27560, 27988, 28398, 28788, 29161, 29516, 29850, 30168, 30467,
    30747, 31011, 31255, 31479, 31686, 31874, 32041, 32193, 32325, 32440,
    32541, 32626, 32693, 32740, 32766, 32765, 32735, 32674, 32584, 32468,
    32330, 32176, 32013, 31847, 31675, 31499, 31307, 31101, 30871, 30613,
    30319, 29993, 29640, 29263, 28872, 28467, 28055, 27637, 27214, 26779,
    26334, 25868, 25382, 24872, 24340, 23790, 23222, 22637, 22039, 21431,
    20812, 20188, 19551, 18901, 18239, 17561, 16872, 16170, 15453, 14727,
    13989, 13242, 12494, 11738, 10972, 10205, 9430, 8659, 7893, 7123,
    6358, 5599, 4840, 4077, 3306, 2529, 1740, 945, 145, -664,
    -1475, -2290, -3103, -3911, -4722, -5531, -6334, -7137, -7931, -8719,
    -9505, -10283, -11052, -11813, -12554, -13281, -13996, -14693, -15378, -16052,
    -16714, -17380, -18043, -18707, -19369, -20019, -20660, -21280, -21879, -22455,
    -23005, -23532, -24044, -24541, -25026, -25502, -25964, -26414, -26856, -27287,
    -27706, -28115, -28518, -28911, -29291, -29655, -29997, -30316, -30603, -30862,
    -31093, -31297, -31477, -31638, -31779, -31902, -32008, -32094, -32165, -32221,
    -32269, -32308, -32341, -32366, -32380, -32375, -32349, -32295, -32211, -32098,
    -31958, -31789, -31599, -31392, -31169, -30929, -30673, -30399, -30109, -29801,
    -29473, -29127, -28763, -28380, -27981, -27566, -27125, -26664, -26180, -25672,
    -25149, -24612, -24064, -23513, -22962, -22417, -21871, -21316, -20751, -20167,
    -19564, -18933, -18273, -17594, -16897, -16190, -15480, -14763, -14046, -13330,
    -12608, -11885, -11153, -10403, -9649, -8890, -8132, -7373, -6603, -5828,
    -5042, -4235, -3424, -2627, -1921, -1246, -436);

  constant LUT_eguitar_a : t_lut_rom := (
    1713, 30807, 25475, 28477, 26338, 27854, 26756, 27715, 26963,
    27490, 27046, 27248, 27038, 26978, 27115, 25726, 14144, 2240, -4541,
    -9552, -10964, -11678, -9161, -6513, -736, 4171, 11702, 16940, 24790,
    26059, 27535, 25402, 28485, 6298, -30272, -29602, -30270, -29844, -29994,
    -29981, -29943, -30010, -29712, -29863, -29415, -29703, -29069, -29837, -21313,
    -5389, 7641, 20173, 27321, 27075, 27197, 27067, 27118, 27054, 27070,
    27007, 27007, 26949, 26958, 26883, 26862, 26729, 26666, 26454, 26563,
    26454, 19688, 9434, 4632, 678, 812, 924, 4771, 7946, 14429,
    19127, 26398, 25064, 28122, 16970, -26861, -31416, -29894, -30898, -30001,
    -30894, -30207, -30942, -30181, -30792, -30039, -30591, -29829, -30499, -22437,
    -9608, -207, 6083, 8536, 9044, 7058, 4242, -650, -5843, -12611,
    -18835, -25926, -29721, -29704, -29800, -29239, -22237, 15902, 29623, 25726,
    28034, 26263, 27671, 26558, 27556, 26596, 27357, 26568, 27116, 26407,
    26935, 26237, 27069, 22789, 12767, 6239, 2117, 536, 511, 2393,
    5428, 9970, 14962, 20871, 25813, 26608, 26318, 26459, 26279, 26386,
    26230, 26232, 26072, 26060, 25952, 25939, 25864, 25842, 25798, 25760,
    25742, 25705, 25682, 25612, 25581, 25502, 25479, 25411, 25374, 25311,
    25259, 25216, 25146, 25113, 25022, 24993, 24856, 24799, 24612, 24645,
    24526, 24401, 23600, 23159, 22531, 22264, 21643, 21208, 20297, 19325,
    17693, 15571, 11970, 6005, -5636, -26749, -32767, -32164, -32768, -32346,
    -32768, -32426, -32762, -32483, -32707, -32409, -32576, -32303, -32448, -32162,
    -32367, -32033, -32536, -29214, -22738, -19298, -18059, -19312, -22161, -26683,
    -31314, -32012, -31735, -31823, -31646, -31733, -31546, -31642, -31411, -31533,
    -31279, -31405, -31100, -31274, -30953, -31175, -30855, -31096, -30772, -30953,
    -30428, -30634, -30332, -30506, -30260, -30327, -30210, -30136, -30197, -29903,
    -30240, -29546, -30182, -29017, -30562, -28099, -32298);


  -------------------------------------------------------------------------------
  -- More Constant Declarations (DDS: Phase increment values for tones in 10 octaves of piano)
  -------------------------------------------------------------------------------
  -------------------------------------------------------------------------------
  -- OCTAVE # Minus-2 (C-2 until B-2)
  constant CM2_DO    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/64, N_CUM));  -- CM2_DO     tone ~(2^-6)*261.63Hz
  constant CM2S_DOS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/64, N_CUM));  -- CM2S_DOS tone ~(2^-6)*277.18Hz
  constant DM2_RE    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/64, N_CUM));  -- DM2_RE     tone ~(2^-6)*293.66Hz
  constant DM2S_RES  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/64, N_CUM));  -- DM2S_RES tone ~(2^-6)*311.13Hz
  constant EM2_MI    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/64, N_CUM));  -- EM2_MI     tone ~(2^-6)*329.63Hz
  constant FM2_FA    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/64, N_CUM));  -- FM2_FA     tone ~(2^-6)*349.23Hz
  constant FM2S_FAS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/64, N_CUM));  -- FM2S_FAS tone ~(2^-6)*369.99Hz
  constant GM2_SOL   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/64, N_CUM));  -- GM2_SOL  tone ~(2^-6)*392.00Hz
  constant GM2S_SOLS : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/64, N_CUM));  -- GM2S_SOLS       tone ~(2^-6)*415.30Hz
  constant AM2_LA    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/64, N_CUM));  -- AM2_LA     tone ~(2^-6)*440.00Hz
  constant AM2S_LAS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/64, N_CUM));  -- AM2S_LAS tone ~(2^-6)*466.16Hz
  constant BM2_SI    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/64, N_CUM));  -- BM2_SI     tone ~(2^-6)*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE # Minus-1 (C-1 until B-1)
  constant CM1_DO    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/32, N_CUM));  -- CM1_DO     tone ~(2^-5)*261.63Hz
  constant CM1S_DOS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/32, N_CUM));  -- CM1S_DOS tone ~(2^-5)*277.18Hz
  constant DM1_RE    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/32, N_CUM));  -- DM1_RE     tone ~(2^-5)*293.66Hz
  constant DM1S_RES  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/32, N_CUM));  -- DM1S_RES tone ~(2^-5)*311.13Hz
  constant EM1_MI    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/32, N_CUM));  -- EM1_MI     tone ~(2^-5)*329.63Hz
  constant FM1_FA    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/32, N_CUM));  -- FM1_FA     tone ~(2^-5)*349.23Hz
  constant FM1S_FAS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/32, N_CUM));  -- FM1S_FAS tone ~(2^-5)*369.99Hz
  constant GM1_SOL   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/32, N_CUM));  -- GM1_SOL  tone ~(2^-5)*392.00Hz
  constant GM1S_SOLS : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/32, N_CUM));  -- GM1S_SOLS       tone ~(2^-5)*415.30Hz
  constant AM1_LA    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/32, N_CUM));  -- AM1_LA     tone ~(2^-5)*440.00Hz
  constant AM1S_LAS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/32, N_CUM));  -- AM1S_LAS tone ~(2^-5)*466.16Hz
  constant BM1_SI    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/32, N_CUM));  -- BM1_SI     tone ~(2^-5)*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #0 (C0 until B0)
  constant C0_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/16, N_CUM));  -- C0_DO               tone ~(2^-4)*261.63Hz
  constant C0S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/16, N_CUM));  -- C0S_DOS   tone ~(2^-4)*277.18Hz
  constant D0_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/16, N_CUM));  -- D0_RE               tone ~(2^-4)*293.66Hz
  constant D0S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/16, N_CUM));  -- D0S_RES   tone ~(2^-4)*311.13Hz
  constant E0_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/16, N_CUM));  -- E0_MI               tone ~(2^-4)*329.63Hz
  constant F0_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/16, N_CUM));  -- F0_FA               tone ~(2^-4)*349.23Hz
  constant F0S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/16, N_CUM));  -- F0S_FAS   tone ~(2^-4)*369.99Hz
  constant G0_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/16, N_CUM));  -- G0_SOL     tone ~(2^-4)*392.00Hz
  constant G0S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/16, N_CUM));  -- G0S_SOLS tone ~(2^-4)*415.30Hz
  constant A0_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/16, N_CUM));  -- A0_LA               tone ~(2^-4)*440.00Hz
  constant A0S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/16, N_CUM));  -- A0S_LAS   tone ~(2^-4)*466.16Hz
  constant B0_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/16, N_CUM));  -- B0_SI               tone ~(2^-4)*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #1 (C1 until B1)
  constant C1_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/8, N_CUM));  -- C1_DO                tone ~(2^-3)*261.63Hz
  constant C1S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/8, N_CUM));  -- C1S_DOS    tone ~(2^-3)*277.18Hz
  constant D1_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/8, N_CUM));  -- D1_RE                tone ~(2^-3)*293.66Hz
  constant D1S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/8, N_CUM));  -- D1S_RES    tone ~(2^-3)*311.13Hz
  constant E1_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/8, N_CUM));  -- E1_MI                tone ~(2^-3)*329.63Hz
  constant F1_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/8, N_CUM));  -- F1_FA                tone ~(2^-3)*349.23Hz
  constant F1S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/8, N_CUM));  -- F1S_FAS    tone ~(2^-3)*369.99Hz
  constant G1_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/8, N_CUM));  -- G1_SOL      tone ~(2^-3)*392.00Hz
  constant G1S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/8, N_CUM));  -- G1S_SOLS  tone ~(2^-3)*415.30Hz
  constant A1_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/8, N_CUM));  -- A1_LA                tone ~(2^-3)*440.00Hz
  constant A1S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/8, N_CUM));  -- A1S_LAS    tone ~(2^-3)*466.16Hz
  constant B1_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/8, N_CUM));  -- B1_SI                tone ~(2^-3)*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #2 (C2 until B2)
  constant C2_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/4, N_CUM));  -- C2_DO                tone ~0,25*261.63Hz
  constant C2S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/4, N_CUM));  -- C2S_DOS    tone ~0,25*277.18Hz
  constant D2_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/4, N_CUM));  -- D2_RE                tone ~0,25*293.66Hz
  constant D2S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/4, N_CUM));  -- D2S_RES    tone ~0,25*311.13Hz
  constant E2_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/4, N_CUM));  -- E2_MI                tone ~0,25*329.63Hz
  constant F2_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/4, N_CUM));  -- F2_FA                tone ~0,25*349.23Hz
  constant F2S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/4, N_CUM));  -- F2S_FAS    tone ~0,25*369.99Hz
  constant G2_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/4, N_CUM));  -- G2_SOL      tone ~0,25*392.00Hz
  constant G2S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/4, N_CUM));  -- G2S_SOLS  tone ~0,25*415.30Hz
  constant A2_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/4, N_CUM));  -- A2_LA                tone ~0,25*440.00Hz
  constant A2S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/4, N_CUM));  -- A2S_LAS    tone ~0,25*466.16Hz
  constant B2_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/4, N_CUM));  -- B2_SI                tone ~0,25*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #3 (C3 until B3)
  constant C3_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858/2, N_CUM));  -- C2_DO                tone ~0,5*261.63Hz
  constant C3S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028/2, N_CUM));  -- C2S_DOS    tone ~0,5*277.18Hz
  constant D3_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208/2, N_CUM));  -- D2_RE                tone ~0,5*293.66Hz
  constant D3S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398/2, N_CUM));  -- D2S_RES    tone ~0,5*311.13Hz
  constant E3_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600/2, N_CUM));  -- E2_MI                tone ~0,5*329.63Hz
  constant F3_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815/2, N_CUM));  -- F2_FA                tone ~0,5*349.23Hz
  constant F3S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041/2, N_CUM));  -- F2S_FAS    tone ~0,5*369.99Hz
  constant G3_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282/2, N_CUM));  -- G2_SOL      tone ~0,5*392.00Hz
  constant G3S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536/2, N_CUM));  -- G2S_SOLS  tone ~0,5*415.30Hz
  constant A3_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806/2, N_CUM));  -- A2_LA                tone ~0,5*440.00Hz
  constant A3S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092/2, N_CUM));  -- A2S_LAS    tone ~0,5*466.16Hz
  constant B3_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394/2, N_CUM));  -- B2_SI                tone ~0,5*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #4 (C4 until B4)
  constant C4_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858, N_CUM));  -- C4_DO          tone ~261.63Hz
  constant C4S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028, N_CUM));  -- C4S_DOS      tone ~277.18Hz
  constant D4_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208, N_CUM));  -- D4_RE          tone ~293.66Hz
  constant D4S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398, N_CUM));  -- D4S_RES      tone ~311.13Hz
  constant E4_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600, N_CUM));  -- E4_MI          tone ~329.63Hz
  constant F4_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815, N_CUM));  -- F4_FA          tone ~349.23Hz
  constant F4S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041, N_CUM));  -- F4S_FAS      tone ~369.99Hz
  constant G4_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282, N_CUM));  -- G4_SOL        tone ~392.00Hz
  constant G4S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536, N_CUM));  -- G4S_SOLS    tone ~415.30Hz
  constant A4_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806, N_CUM));  -- A4_LA          tone ~440.00Hz
  constant A4S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092, N_CUM));  -- A4S_LAS      tone ~466.16Hz
  constant B4_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394, N_CUM));  -- B4_SI          tone ~493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #5 (C5 until B5)
  constant C5_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858*2, N_CUM));  -- C5_DO                tone ~2*261.63Hz
  constant C5S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028*2, N_CUM));  -- C5S_DOS    tone ~2*277.18Hz
  constant D5_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208*2, N_CUM));  -- D5_RE                tone ~2*293.66Hz
  constant D5S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398*2, N_CUM));  -- D5S_RES    tone ~2*311.13Hz
  constant E5_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600*2, N_CUM));  -- E5_MI                tone ~2*329.63Hz
  constant F5_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815*2, N_CUM));  -- F5_FA                tone ~2*349.23Hz
  constant F5S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041*2, N_CUM));  -- F5S_FAS    tone ~2*369.99Hz
  constant G5_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282*2, N_CUM));  -- G5_SOL      tone ~2*392.00Hz
  constant G5S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536*2, N_CUM));  -- G5S_SOLS  tone ~2*415.30Hz
  constant A5_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806*2, N_CUM));  -- A5_LA                tone ~2*440.00Hz
  constant A5S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092*2, N_CUM));  -- A5S_LAS    tone ~2*466.16Hz
  constant B5_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394*2, N_CUM));  -- B5_SI                tone ~2*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #6 (C6 until B6)
  constant C6_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858*4, N_CUM));  -- C6_DO                tone ~4*261.63Hz
  constant C6S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028*4, N_CUM));  -- C6S_DOS    tone ~4*277.18Hz
  constant D6_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208*4, N_CUM));  -- D6_RE                tone ~4*293.66Hz
  constant D6S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398*4, N_CUM));  -- D6S_RES    tone ~4*311.13Hz
  constant E6_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600*4, N_CUM));  -- E6_MI                tone ~4*329.63Hz
  constant F6_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815*4, N_CUM));  -- F6_FA                tone ~4*349.23Hz
  constant F6S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041*4, N_CUM));  -- F6S_FAS    tone ~4*369.99Hz
  constant G6_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282*4, N_CUM));  -- G6_SOL      tone ~4*392.00Hz
  constant G6S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536*4, N_CUM));  -- G6S_SOLS  tone ~4*415.30Hz
  constant A6_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806*4, N_CUM));  -- A6_LA                tone ~4*440.00Hz
  constant A6S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092*4, N_CUM));  -- A6S_LAS    tone ~4*466.16Hz
  constant B6_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394*4, N_CUM));  -- B6_SI                tone ~4*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #7 (C7 until B7)
  constant C7_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858*8, N_CUM));  -- C7_DO                tone ~8*261.63Hz
  constant C7S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028*8, N_CUM));  -- C7S_DOS    tone ~8*277.18Hz
  constant D7_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208*8, N_CUM));  -- D7_RE                tone ~8*293.66Hz
  constant D7S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398*8, N_CUM));  -- D7S_RES    tone ~8*311.13Hz
  constant E7_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600*8, N_CUM));  -- E7_MI                tone ~8*329.63Hz
  constant F7_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815*8, N_CUM));  -- F7_FA                tone ~8*349.23Hz
  constant F7S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041*8, N_CUM));  -- F7S_FAS    tone ~8*369.99Hz
  constant G7_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282*8, N_CUM));  -- G7_SOL      tone ~8*392.00Hz
  constant G7S_SOLS  : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4536*8, N_CUM));  -- G7S_SOLS  tone ~8*415.30Hz
  constant A7_LA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4806*8, N_CUM));  -- A7_LA                tone ~8*440.00Hz
  constant A7S_LAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5092*8, N_CUM));  -- A7S_LAS    tone ~8*466.16Hz
  constant B7_SI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(5394*8, N_CUM));  -- B7_SI                tone ~8*493.88Hz
  -------------------------------------------------------------------------------
  -- OCTAVE #8 (C8 until G8)
  constant C8_DO     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(2858*16, N_CUM));  -- C8_DO               tone ~16*261.63Hz
  constant C8S_DOS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3028*16, N_CUM));  -- C8S_DOS   tone ~16*277.18Hz
  constant D8_RE     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3208*16, N_CUM));  -- D8_RE               tone ~16*293.66Hz
  constant D8S_RES   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3398*16, N_CUM));  -- D8S_RES   tone ~16*311.13Hz
  constant E8_MI     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3600*16, N_CUM));  -- E8_MI               tone ~16*329.63Hz
  constant F8_FA     : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(3815*16, N_CUM));  -- F8_FA               tone ~16*349.23Hz
  constant F8S_FAS   : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4041*16, N_CUM));  -- F8S_FAS   tone ~16*369.99Hz
  constant G8_SOL    : std_logic_vector(N_CUM-1 downto 0) := std_logic_vector(to_unsigned(4282*16, N_CUM));  -- G8_SOL     tone ~16*392.00Hz
  -- STOP MIDI RANGE ------------------------------------------------------------       


  -------------------------------------------------------------------------------
  -- TYPE AND LUT FOR MIDI NOTE_NUMBER (need to translate midi_cmd.number for dds.phi_incr)
  -------------------------------------------------------------------------------
  type t_lut_note_number is array (0 to 127) of std_logic_vector(N_CUM-1 downto 0);

  constant LUT_midi2dds : t_lut_note_number := (
    0   => CM2_DO,
    1   => CM2S_DOS,
    2   => DM2_RE,
    3   => DM2S_RES,
    4   => EM2_MI,
    5   => FM2_FA,
    6   => FM2S_FAS,
    7   => GM2_SOL,
    8   => GM2S_SOLS,
    9   => AM2_LA,
    10  => AM2S_LAS,
    11  => BM2_SI,
    12  => CM1_DO,
    13  => CM1S_DOS,
    14  => DM1_RE,
    15  => DM1S_RES,
    16  => EM1_MI,
    17  => FM1_FA,
    18  => FM1S_FAS,
    19  => GM1_SOL,
    20  => GM1S_SOLS,
    21  => AM1_LA,
    22  => AM1S_LAS,
    23  => BM1_SI,
    24  => C0_DO,
    25  => C0S_DOS,
    26  => D0_RE,
    27  => D0S_RES,
    28  => E0_MI,
    29  => F0_FA,
    30  => F0S_FAS,
    31  => G0_SOL,
    32  => G0S_SOLS,
    33  => A0_LA,
    34  => A0S_LAS,
    35  => B0_SI,
    36  => C1_DO,
    37  => C1S_DOS,
    38  => D1_RE,
    39  => D1S_RES,
    40  => E1_MI,
    41  => F1_FA,
    42  => F1S_FAS,
    43  => G1_SOL,
    44  => G1S_SOLS,
    45  => A1_LA,
    46  => A1S_LAS,
    47  => B1_SI,
    48  => C2_DO,
    49  => C2S_DOS,
    50  => D2_RE,
    51  => D2S_RES,
    52  => E2_MI,
    53  => F2_FA,
    54  => F2S_FAS,
    55  => G2_SOL,
    56  => G2S_SOLS,
    57  => A2_LA,
    58  => A2S_LAS,
    59  => B2_SI,
    60  => C3_DO,
    61  => C3S_DOS,
    62  => D3_RE,
    63  => D3S_RES,
    64  => E3_MI,
    65  => F3_FA,
    66  => F3S_FAS,
    67  => G3_SOL,
    68  => G3S_SOLS,
    69  => A3_LA,
    70  => A3S_LAS,
    71  => B3_SI,
    72  => C4_DO,
    73  => C4S_DOS,
    74  => D4_RE,
    75  => D4S_RES,
    76  => E4_MI,
    77  => F4_FA,
    78  => F4S_FAS,
    79  => G4_SOL,
    80  => G4S_SOLS,
    81  => A4_LA,
    82  => A4S_LAS,
    83  => B4_SI,
    84  => C5_DO,
    85  => C5S_DOS,
    86  => D5_RE,
    87  => D5S_RES,
    88  => E5_MI,
    89  => F5_FA,
    90  => F5S_FAS,
    91  => G5_SOL,
    92  => G5S_SOLS,
    93  => A5_LA,
    94  => A5S_LAS,
    95  => B5_SI,
    96  => C6_DO,
    97  => C6S_DOS,
    98  => D6_RE,
    99  => D6S_RES,
    100 => E6_MI,
    101 => F6_FA,
    102 => F6S_FAS,
    103 => G6_SOL,
    104 => G6S_SOLS,
    105 => A6_LA,
    106 => A6S_LAS,
    107 => B6_SI,
    108 => C7_DO,
    109 => C7S_DOS,
    110 => D7_RE,
    111 => D7S_RES,
    112 => E7_MI,
    113 => F7_FA,
    114 => F7S_FAS,
    115 => G7_SOL,
    116 => G7S_SOLS,
    117 => A7_LA,
    118 => A7S_LAS,
    119 => B7_SI,
    120 => C8_DO,
    121 => C8S_DOS,
    122 => D8_RE,
    123 => D8S_RES,
    124 => E8_MI,
    125 => F8_FA,
    126 => F8S_FAS,
    127 => G8_SOL
    );

-------------------------------------------------------------------------------         
end package;
