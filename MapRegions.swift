import SwiftUI

struct MapRegion {
    let id: String
    let path: Path
}

enum MapRegions {
    static let all: [MapRegion] = [
        // Crystal City
        MapRegion(id: "C09", path: Path { p in
            p.move(to: CGPoint(x: 794, y: 1414))
            p.addLine(to: CGPoint(x: 836, y: 1453))
            p.addLine(to: CGPoint(x: 975, y: 1303))
            p.addLine(to: CGPoint(x: 934, y: 1270))
            p.closeSubpath()
        }),
        // Van Dorn St
        MapRegion(id: "J02", path: Path { p in
            p.move(to: CGPoint(x: 598, y: 1397))
            p.addLine(to: CGPoint(x: 743, y: 1557))
            p.addLine(to: CGPoint(x: 800, y: 1511))
            p.addLine(to: CGPoint(x: 637, y: 1360))
            p.closeSubpath()
        }),
        // Waterfront
        MapRegion(id: "F04", path: Path { p in
            p.move(to: CGPoint(x: 1278, y: 1097))
            p.addLine(to: CGPoint(x: 1153, y: 1225))
            p.addLine(to: CGPoint(x: 1137, y: 1205))
            p.addLine(to: CGPoint(x: 1257, y: 1083))
            p.closeSubpath()
        }),
        // Navy Yard-Ballpark
        MapRegion(id: "F05", path: Path { p in
            p.move(to: CGPoint(x: 1319, y: 1112))
            p.addLine(to: CGPoint(x: 1160, y: 1275))
            p.addLine(to: CGPoint(x: 1137, y: 1247))
            p.addLine(to: CGPoint(x: 1293, y: 1091))
            p.closeSubpath()
        }),
        // Anacostia
        MapRegion(id: "F06", path: Path { p in
            p.move(to: CGPoint(x: 1412, y: 1156))
            p.addLine(to: CGPoint(x: 1288, y: 1269))
            p.addLine(to: CGPoint(x: 1259, y: 1233))
            p.addLine(to: CGPoint(x: 1384, y: 1126))
            p.closeSubpath()
        }),
        // Congress Heights
        MapRegion(id: "F07", path: Path { p in
            p.move(to: CGPoint(x: 1443, y: 1184))
            p.addLine(to: CGPoint(x: 1300, y: 1324))
            p.addLine(to: CGPoint(x: 1272, y: 1301))
            p.addLine(to: CGPoint(x: 1419, y: 1158))
            p.closeSubpath()
        }),
        // Southern Av
        MapRegion(id: "F08", path: Path { p in
            p.move(to: CGPoint(x: 1517, y: 1172))
            p.addLine(to: CGPoint(x: 1348, y: 1344))
            p.addLine(to: CGPoint(x: 1319, y: 1317))
            p.addLine(to: CGPoint(x: 1488, y: 1157))
            p.closeSubpath()
        }),
        // Naylor Rd
        MapRegion(id: "F09", path: Path { p in
            p.move(to: CGPoint(x: 1559, y: 1200))
            p.addLine(to: CGPoint(x: 1428, y: 1327))
            p.addLine(to: CGPoint(x: 1397, y: 1297))
            p.addLine(to: CGPoint(x: 1527, y: 1176))
            p.closeSubpath()
        }),
        // Suitland
        MapRegion(id: "F10", path: Path { p in
            p.move(to: CGPoint(x: 1596, y: 1238))
            p.addLine(to: CGPoint(x: 1470, y: 1358))
            p.addLine(to: CGPoint(x: 1437, y: 1329))
            p.addLine(to: CGPoint(x: 1564, y: 1210))
            p.closeSubpath()
        }),
        // Branch Av
        MapRegion(id: "F11", path: Path { p in
            p.move(to: CGPoint(x: 1477, y: 1376))
            p.addLine(to: CGPoint(x: 1514, y: 1409))
            p.addLine(to: CGPoint(x: 1640, y: 1281))
            p.addLine(to: CGPoint(x: 1601, y: 1241))
            p.closeSubpath()
        }),
        // Downtown Largo
        MapRegion(id: "G05", path: Path { p in
            p.move(to: CGPoint(x: 1975, y: 1083))
            p.addLine(to: CGPoint(x: 1833, y: 932))
            p.addLine(to: CGPoint(x: 1822, y: 876))
            p.addLine(to: CGPoint(x: 1875, y: 878))
            p.addLine(to: CGPoint(x: 1876, y: 940))
            p.addLine(to: CGPoint(x: 1998, y: 1065))
            p.closeSubpath()
        }),
        // Morgan Blvd
        MapRegion(id: "G04", path: Path { p in
            p.move(to: CGPoint(x: 1900, y: 1051))
            p.addLine(to: CGPoint(x: 1784, y: 934))
            p.addLine(to: CGPoint(x: 1782, y: 875))
            p.addLine(to: CGPoint(x: 1818, y: 878))
            p.addLine(to: CGPoint(x: 1831, y: 933))
            p.addLine(to: CGPoint(x: 1936, y: 1043))
            p.closeSubpath()
        }),
        // Addison Rd
        MapRegion(id: "G03", path: Path { p in
            p.move(to: CGPoint(x: 1847, y: 1045))
            p.addLine(to: CGPoint(x: 1734, y: 928))
            p.addLine(to: CGPoint(x: 1729, y: 875))
            p.addLine(to: CGPoint(x: 1771, y: 877))
            p.addLine(to: CGPoint(x: 1776, y: 934))
            p.addLine(to: CGPoint(x: 1882, y: 1036))
            p.closeSubpath()
        }),
        // Capitol Heights
        MapRegion(id: "G02", path: Path { p in
            p.move(to: CGPoint(x: 1816, y: 1066))
            p.addLine(to: CGPoint(x: 1690, y: 932))
            p.addLine(to: CGPoint(x: 1684, y: 876))
            p.addLine(to: CGPoint(x: 1729, y: 882))
            p.addLine(to: CGPoint(x: 1732, y: 931))
            p.addLine(to: CGPoint(x: 1845, y: 1045))
            p.closeSubpath()
        }),
        // Benning Rd
        MapRegion(id: "G01", path: Path { p in
            p.move(to: CGPoint(x: 1763, y: 1016))
            p.addLine(to: CGPoint(x: 1676, y: 925))
            p.addLine(to: CGPoint(x: 1675, y: 877))
            p.addLine(to: CGPoint(x: 1628, y: 879))
            p.addLine(to: CGPoint(x: 1634, y: 929))
            p.addLine(to: CGPoint(x: 1737, y: 1035))
            p.closeSubpath()
        }),
        // Stadium-Armory
        MapRegion(id: "D08", path: Path { p in
            p.move(to: CGPoint(x: 1418, y: 865))
            p.addLine(to: CGPoint(x: 1602, y: 1060))
            p.addLine(to: CGPoint(x: 1638, y: 1023))
            p.addLine(to: CGPoint(x: 1466, y: 828))
            p.closeSubpath()
        }),
        // Potomac Av
        MapRegion(id: "D07", path: Path { p in
            p.move(to: CGPoint(x: 1371, y: 898))
            p.addLine(to: CGPoint(x: 1527, y: 1040))
            p.addLine(to: CGPoint(x: 1542, y: 1016))
            p.addLine(to: CGPoint(x: 1400, y: 867))
            p.closeSubpath()
        }),
        // Eastern Market
        MapRegion(id: "D06", path: Path { p in
            p.move(to: CGPoint(x: 1340, y: 931))
            p.addLine(to: CGPoint(x: 1496, y: 1080))
            p.addLine(to: CGPoint(x: 1517, y: 1049))
            p.addLine(to: CGPoint(x: 1362, y: 903))
            p.closeSubpath()
        }),
        // Capitol South
        MapRegion(id: "D05", path: Path { p in
            p.move(to: CGPoint(x: 1291, y: 927))
            p.addLine(to: CGPoint(x: 1300, y: 981))
            p.addLine(to: CGPoint(x: 1414, y: 1099))
            p.addLine(to: CGPoint(x: 1439, y: 1074))
            p.addLine(to: CGPoint(x: 1342, y: 979))
            p.addLine(to: CGPoint(x: 1327, y: 917))
            p.closeSubpath()
        }),
        // Federal Center SW
        MapRegion(id: "D04", path: Path { p in
            p.move(to: CGPoint(x: 1232, y: 922))
            p.addLine(to: CGPoint(x: 1235, y: 1000))
            p.addLine(to: CGPoint(x: 1395, y: 1132))
            p.addLine(to: CGPoint(x: 1414, y: 1107))
            p.addLine(to: CGPoint(x: 1284, y: 978))
            p.addLine(to: CGPoint(x: 1269, y: 917))
            p.closeSubpath()
        }),
        // L'Enfant Plaza
        MapRegion(id: "F03,D03", path: Path { p in
            p.move(to: CGPoint(x: 1180, y: 893))
            p.addLine(to: CGPoint(x: 1031, y: 1040))
            p.addLine(to: CGPoint(x: 1091, y: 1095))
            p.addLine(to: CGPoint(x: 1227, y: 941))
            p.closeSubpath()
        }),
        // Archives
        MapRegion(id: "F02", path: Path { p in
            p.move(to: CGPoint(x: 1172, y: 828))
            p.addLine(to: CGPoint(x: 1043, y: 959))
            p.addLine(to: CGPoint(x: 1069, y: 992))
            p.addLine(to: CGPoint(x: 1207, y: 846))
            p.closeSubpath()
        }),
        // Smithsonian
        MapRegion(id: "D02", path: Path { p in
            p.move(to: CGPoint(x: 918, y: 998))
            p.addLine(to: CGPoint(x: 1035, y: 882))
            p.addLine(to: CGPoint(x: 1084, y: 881))
            p.addLine(to: CGPoint(x: 1085, y: 914))
            p.addLine(to: CGPoint(x: 939, y: 1017))
            p.closeSubpath()
        }),
        // Federal Triangle
        MapRegion(id: "D01", path: Path { p in
            p.move(to: CGPoint(x: 917, y: 989))
            p.addLine(to: CGPoint(x: 917, y: 989))
            p.addLine(to: CGPoint(x: 1035, y: 874))
            p.addLine(to: CGPoint(x: 1075, y: 873))
            p.addLine(to: CGPoint(x: 1070, y: 830))
            p.addLine(to: CGPoint(x: 1037, y: 836))
            p.addLine(to: CGPoint(x: 886, y: 963))
            p.closeSubpath()
        }),
        // Metro Center
        MapRegion(id: "C01,A01", path: Path { p in
            p.move(to: CGPoint(x: 899, y: 890))
            p.addLine(to: CGPoint(x: 926, y: 923))
            p.addLine(to: CGPoint(x: 1098, y: 784))
            p.addLine(to: CGPoint(x: 1049, y: 745))
            p.closeSubpath()
        }),
        // Ashburn
        MapRegion(id: "N12", path: Path { p in
            p.move(to: CGPoint(x: 33, y: 491))
            p.addLine(to: CGPoint(x: 156, y: 378))
            p.addLine(to: CGPoint(x: 185, y: 408))
            p.addLine(to: CGPoint(x: 64, y: 523))
            p.closeSubpath()
        }),
        // Loudoun Gateway
        MapRegion(id: "N11", path: Path { p in
            p.move(to: CGPoint(x: 63, y: 525))
            p.addLine(to: CGPoint(x: 91, y: 555))
            p.addLine(to: CGPoint(x: 273, y: 375))
            p.addLine(to: CGPoint(x: 250, y: 346))
            p.closeSubpath()
        }),
        // Washington Dulles International Airport
        MapRegion(id: "N10", path: Path { p in
            p.move(to: CGPoint(x: 93, y: 557))
            p.addLine(to: CGPoint(x: 125, y: 590))
            p.addLine(to: CGPoint(x: 305, y: 408))
            p.addLine(to: CGPoint(x: 278, y: 373))
            p.closeSubpath()
        }),
        // Innovation Center
        MapRegion(id: "N09", path: Path { p in
            p.move(to: CGPoint(x: 126, y: 592))
            p.addLine(to: CGPoint(x: 158, y: 619))
            p.addLine(to: CGPoint(x: 338, y: 445))
            p.addLine(to: CGPoint(x: 308, y: 412))
            p.closeSubpath()
        }),
        // Herndon
        MapRegion(id: "N08", path: Path { p in
            p.move(to: CGPoint(x: 160, y: 622))
            p.addLine(to: CGPoint(x: 186, y: 654))
            p.addLine(to: CGPoint(x: 363, y: 475))
            p.addLine(to: CGPoint(x: 340, y: 449))
            p.closeSubpath()
        }),
        // Reston Town Center
        MapRegion(id: "N07", path: Path { p in
            p.move(to: CGPoint(x: 190, y: 656))
            p.addLine(to: CGPoint(x: 218, y: 682))
            p.addLine(to: CGPoint(x: 395, y: 506))
            p.addLine(to: CGPoint(x: 367, y: 481))
            p.closeSubpath()
        }),
        // Wiehle-Reston East
        MapRegion(id: "N06", path: Path { p in
            p.move(to: CGPoint(x: 219, y: 677))
            p.addLine(to: CGPoint(x: 243, y: 708))
            p.addLine(to: CGPoint(x: 422, y: 534))
            p.addLine(to: CGPoint(x: 392, y: 509))
            p.closeSubpath()
        }),
        // Spring Hill
        MapRegion(id: "N04", path: Path { p in
            p.move(to: CGPoint(x: 247, y: 712))
            p.addLine(to: CGPoint(x: 272, y: 734))
            p.addLine(to: CGPoint(x: 382, y: 631))
            p.addLine(to: CGPoint(x: 352, y: 609))
            p.closeSubpath()
        }),
        // Greensboro
        MapRegion(id: "N03", path: Path { p in
            p.move(to: CGPoint(x: 282, y: 738))
            p.addLine(to: CGPoint(x: 304, y: 765))
            p.addLine(to: CGPoint(x: 417, y: 657))
            p.addLine(to: CGPoint(x: 389, y: 637))
            p.closeSubpath()
        }),
        // Tysons
        MapRegion(id: "N02", path: Path { p in
            p.move(to: CGPoint(x: 309, y: 771))
            p.addLine(to: CGPoint(x: 333, y: 798))
            p.addLine(to: CGPoint(x: 457, y: 677))
            p.addLine(to: CGPoint(x: 429, y: 655))
            p.closeSubpath()
        }),
        // McLean
        MapRegion(id: "N01", path: Path { p in
            p.move(to: CGPoint(x: 340, y: 804))
            p.addLine(to: CGPoint(x: 371, y: 823))
            p.addLine(to: CGPoint(x: 450, y: 743))
            p.addLine(to: CGPoint(x: 422, y: 722))
            p.closeSubpath()
        }),
        // Vienna
        MapRegion(id: "K08", path: Path { p in
            p.move(to: CGPoint(x: 127, y: 921))
            p.addLine(to: CGPoint(x: 201, y: 861))
            p.addLine(to: CGPoint(x: 224, y: 820))
            p.addLine(to: CGPoint(x: 277, y: 820))
            p.addLine(to: CGPoint(x: 255, y: 851))
            p.addLine(to: CGPoint(x: 153, y: 952))
            p.closeSubpath()
        }),
        // Dunn Loring
        MapRegion(id: "K07", path: Path { p in
            p.move(to: CGPoint(x: 154, y: 954))
            p.addLine(to: CGPoint(x: 289, y: 817))
            p.addLine(to: CGPoint(x: 336, y: 818))
            p.addLine(to: CGPoint(x: 328, y: 842))
            p.addLine(to: CGPoint(x: 175, y: 987))
            p.closeSubpath()
        }),
        // West Falls Church
        MapRegion(id: "K06", path: Path { p in
            p.move(to: CGPoint(x: 186, y: 980))
            p.addLine(to: CGPoint(x: 351, y: 822))
            p.addLine(to: CGPoint(x: 399, y: 822))
            p.addLine(to: CGPoint(x: 391, y: 862))
            p.addLine(to: CGPoint(x: 214, y: 1016))
            p.closeSubpath()
        }),
        // East Falls Church
        MapRegion(id: "K05", path: Path { p in
            p.move(to: CGPoint(x: 267, y: 1001))
            p.addLine(to: CGPoint(x: 398, y: 868))
            p.addLine(to: CGPoint(x: 420, y: 813))
            p.addLine(to: CGPoint(x: 479, y: 820))
            p.addLine(to: CGPoint(x: 471, y: 883))
            p.addLine(to: CGPoint(x: 287, y: 1032))
            p.closeSubpath()
        }),
        // Ballston-MU
        MapRegion(id: "K04", path: Path { p in
            p.move(to: CGPoint(x: 380, y: 958))
            p.addLine(to: CGPoint(x: 477, y: 878))
            p.addLine(to: CGPoint(x: 484, y: 825))
            p.addLine(to: CGPoint(x: 526, y: 826))
            p.addLine(to: CGPoint(x: 522, y: 871))
            p.addLine(to: CGPoint(x: 402, y: 984))
            p.closeSubpath()
        }),
        // Virginia Sq-GMU
        MapRegion(id: "K03", path: Path { p in
            p.move(to: CGPoint(x: 406, y: 987))
            p.addLine(to: CGPoint(x: 523, y: 872))
            p.addLine(to: CGPoint(x: 528, y: 824))
            p.addLine(to: CGPoint(x: 568, y: 826))
            p.addLine(to: CGPoint(x: 568, y: 871))
            p.addLine(to: CGPoint(x: 423, y: 1010))
            p.closeSubpath()
        }),
        // Clarendon
        MapRegion(id: "K02", path: Path { p in
            p.move(to: CGPoint(x: 494, y: 939))
            p.addLine(to: CGPoint(x: 569, y: 869))
            p.addLine(to: CGPoint(x: 573, y: 829))
            p.addLine(to: CGPoint(x: 615, y: 830))
            p.addLine(to: CGPoint(x: 611, y: 871))
            p.addLine(to: CGPoint(x: 509, y: 967))
            p.closeSubpath()
        }),
        // Court House
        MapRegion(id: "K01", path: Path { p in
            p.move(to: CGPoint(x: 518, y: 962))
            p.addLine(to: CGPoint(x: 614, y: 870))
            p.addLine(to: CGPoint(x: 619, y: 827))
            p.addLine(to: CGPoint(x: 665, y: 827))
            p.addLine(to: CGPoint(x: 662, y: 886))
            p.addLine(to: CGPoint(x: 535, y: 989))
            p.closeSubpath()
        }),
        // Rosslyn
        MapRegion(id: "C05", path: Path { p in
            p.move(to: CGPoint(x: 514, y: 764))
            p.addLine(to: CGPoint(x: 516, y: 818))
            p.addLine(to: CGPoint(x: 723, y: 815))
            p.addLine(to: CGPoint(x: 745, y: 758))
            p.closeSubpath()
        }),
        // Foggy Bottom-GWU
        MapRegion(id: "C04", path: Path { p in
            p.move(to: CGPoint(x: 878, y: 673))
            p.addLine(to: CGPoint(x: 875, y: 733))
            p.addLine(to: CGPoint(x: 755, y: 855))
            p.addLine(to: CGPoint(x: 728, y: 810))
            p.addLine(to: CGPoint(x: 831, y: 723))
            p.addLine(to: CGPoint(x: 840, y: 666))
            p.closeSubpath()
        }),
        // Farragut West
        MapRegion(id: "C03", path: Path { p in
            p.move(to: CGPoint(x: 884, y: 672))
            p.addLine(to: CGPoint(x: 882, y: 737))
            p.addLine(to: CGPoint(x: 797, y: 827))
            p.addLine(to: CGPoint(x: 822, y: 857))
            p.addLine(to: CGPoint(x: 932, y: 746))
            p.addLine(to: CGPoint(x: 937, y: 671))
            p.closeSubpath()
        }),
        // McPherson Sq
        MapRegion(id: "C02", path: Path { p in
            p.move(to: CGPoint(x: 980, y: 664))
            p.addLine(to: CGPoint(x: 976, y: 745))
            p.addLine(to: CGPoint(x: 1124, y: 741))
            p.addLine(to: CGPoint(x: 1121, y: 662))
            p.closeSubpath()
        }),
        // Judiciary Sq
        MapRegion(id: "B02", path: Path { p in
            p.move(to: CGPoint(x: 1228, y: 784))
            p.addLine(to: CGPoint(x: 1342, y: 903))
            p.addLine(to: CGPoint(x: 1382, y: 865))
            p.addLine(to: CGPoint(x: 1262, y: 752))
            p.closeSubpath()
        }),
        // Gallery Place
        MapRegion(id: "B01,F01", path: Path { p in
            p.move(to: CGPoint(x: 1141, y: 776))
            p.addLine(to: CGPoint(x: 1280, y: 655))
            p.addLine(to: CGPoint(x: 1314, y: 690))
            p.addLine(to: CGPoint(x: 1176, y: 824))
            p.addLine(to: CGPoint(x: 1136, y: 781))
            p.closeSubpath()
        }),
        // Mt Vernon Sq
        MapRegion(id: "E01", path: Path { p in
            p.move(to: CGPoint(x: 1149, y: 715))
            p.addLine(to: CGPoint(x: 1297, y: 586))
            p.addLine(to: CGPoint(x: 1319, y: 614))
            p.addLine(to: CGPoint(x: 1174, y: 748))
            p.closeSubpath()
        }),
        // Shaw-Howard U
        MapRegion(id: "E02", path: Path { p in
            p.move(to: CGPoint(x: 1144, y: 650))
            p.addLine(to: CGPoint(x: 1144, y: 650))
            p.addLine(to: CGPoint(x: 1290, y: 513))
            p.addLine(to: CGPoint(x: 1329, y: 557))
            p.addLine(to: CGPoint(x: 1175, y: 685))
            p.closeSubpath()
        }),
        // Georgia Av Petworth
        MapRegion(id: "E05", path: Path { p in
            p.move(to: CGPoint(x: 985, y: 316))
            p.addLine(to: CGPoint(x: 950, y: 356))
            p.addLine(to: CGPoint(x: 1130, y: 523))
            p.addLine(to: CGPoint(x: 1163, y: 491))
            p.closeSubpath()
        }),
        // Arlington Cemetery
        MapRegion(id: "C06", path: Path { p in
            p.addRect(CGRect(x: 595, y: 1010, width: 256, height: 44))
        }),
        // Pentagon
        MapRegion(id: "C07", path: Path { p in
            p.addRect(CGRect(x: 773, y: 1125, width: 184, height: 54))
        }),
        // Pentagon City
        MapRegion(id: "C08", path: Path { p in
            p.addRect(CGRect(x: 727, y: 1214, width: 205, height: 48))
        }),
        // Ronald Reagan Washington National Airport
        MapRegion(id: "C10", path: Path { p in
            p.addRect(CGRect(x: 971, y: 1321, width: 322, height: 53))
        }),
        // Braddock Rd
        MapRegion(id: "C12", path: Path { p in
            p.addRect(CGRect(x: 969, y: 1407, width: 196, height: 30))
        }),
        // Potomac Yard
        MapRegion(id: "C122", path: Path { p in
            p.addRect(CGRect(x: 969, y: 1377, width: 206, height: 25))
        }),
        // King St-Old Town
        MapRegion(id: "C13", path: Path { p in
            p.addRect(CGRect(x: 964, y: 1451, width: 294, height: 50))
        }),
        // Eisenhower Av
        MapRegion(id: "C14", path: Path { p in
            p.addRect(CGRect(x: 994, y: 1523, width: 194, height: 46))
        }),
        // Huntington
        MapRegion(id: "C15", path: Path { p in
            p.addRect(CGRect(x: 993, y: 1594, width: 197, height: 56))
        }),
        // Franconia-Springfield
        MapRegion(id: "J03", path: Path { p in
            p.addRect(CGRect(x: 384, y: 1591, width: 335, height: 72))
        }),
        // Minnesota Av
        MapRegion(id: "D09", path: Path { p in
            p.addRect(CGRect(x: 1569, y: 830, width: 231, height: 30))
        }),
        // Deanwood
        MapRegion(id: "D10", path: Path { p in
            p.addRect(CGRect(x: 1605, y: 793, width: 192, height: 32))
        }),
        // Cheverly
        MapRegion(id: "D11", path: Path { p in
            p.addRect(CGRect(x: 1642, y: 754, width: 176, height: 35))
        }),
        // Landover
        MapRegion(id: "D12", path: Path { p in
            p.addRect(CGRect(x: 1683, y: 718, width: 184, height: 31))
        }),
        // New Carrollton
        MapRegion(id: "D13", path: Path { p in
            p.addRect(CGRect(x: 1719, y: 670, width: 238, height: 45))
        }),
        // Union Station
        MapRegion(id: "B03", path: Path { p in
            p.addRect(CGRect(x: 1321, y: 731, width: 262, height: 50))
        }),
        // NoMa-Gallaudet U
        MapRegion(id: "B35", path: Path { p in
            p.addRect(CGRect(x: 1315, y: 680, width: 231, height: 31))
        }),
        // Rhode Island Av
        MapRegion(id: "B04", path: Path { p in
            p.addRect(CGRect(x: 1318, y: 625, width: 235, height: 41))
        }),
        // Brookland-CUA
        MapRegion(id: "B05", path: Path { p in
            p.addRect(CGRect(x: 1319, y: 569, width: 194, height: 35))
        }),
        // U St
        MapRegion(id: "E03", path: Path { p in
            p.addRect(CGRect(x: 985, y: 570, width: 185, height: 53))
        }),
        // Columbia Heights
        MapRegion(id: "E04", path: Path { p in
            p.addRect(CGRect(x: 968, y: 518, width: 149, height: 41))
        }),
        // Fort Totten
        MapRegion(id: "E06,B06", path: Path { p in
            p.addRect(CGRect(x: 1187, y: 429, width: 267, height: 58))
        }),
        // West Hyattsville
        MapRegion(id: "E07", path: Path { p in
            p.addRect(CGRect(x: 1271, y: 380, width: 281, height: 33))
        }),
        // Hyattsville Crossing
        MapRegion(id: "E08", path: Path { p in
            p.addRect(CGRect(x: 1322, y: 341, width: 291, height: 36))
        }),
        // College Park-U of MD
        MapRegion(id: "E09", path: Path { p in
            p.addRect(CGRect(x: 1354, y: 300, width: 338, height: 39))
        }),
        // Greenbelt
        MapRegion(id: "E10", path: Path { p in
            p.addRect(CGRect(x: 1380, y: 263, width: 314, height: 33))
        }),
        // Takoma
        MapRegion(id: "B07", path: Path { p in
            p.addRect(CGRect(x: 1082, y: 317, width: 181, height: 43))
        }),
        // Silver Spring
        MapRegion(id: "B08", path: Path { p in
            p.addRect(CGRect(x: 1067, y: 196, width: 250, height: 40))
        }),
        // Forest Glen
        MapRegion(id: "B09", path: Path { p in
            p.addRect(CGRect(x: 1071, y: 147, width: 212, height: 37))
        }),
        // Wheaton
        MapRegion(id: "B10", path: Path { p in
            p.addRect(CGRect(x: 1070, y: 95, width: 165, height: 29))
        }),
        // Glenmont
        MapRegion(id: "B11", path: Path { p in
            p.addRect(CGRect(x: 1072, y: 43, width: 167, height: 36))
        }),
        // Farragut North
        MapRegion(id: "A02", path: Path { p in
            p.addRect(CGRect(x: 793, y: 625, width: 191, height: 29))
        }),
        // Dupont Circle
        MapRegion(id: "A03", path: Path { p in
            p.addRect(CGRect(x: 776, y: 588, width: 191, height: 31))
        }),
        // Woodley Park
        MapRegion(id: "A04", path: Path { p in
            p.addRect(CGRect(x: 738, y: 547, width: 189, height: 38))
        }),
        // Cleveland Park
        MapRegion(id: "A05", path: Path { p in
            p.addRect(CGRect(x: 704, y: 519, width: 186, height: 27))
        }),
        // Van Ness-UDC
        MapRegion(id: "A06", path: Path { p in
            p.move(to: CGPoint(x: 943, y: 384))
            p.addLine(to: CGPoint(x: 815, y: 505))
            p.addLine(to: CGPoint(x: 836, y: 524))
            p.addLine(to: CGPoint(x: 962, y: 404))
            p.addLine(to: CGPoint(x: 944, y: 384))
            p.closeSubpath()
        }),
        // Tenleytown-AU
        MapRegion(id: "A07", path: Path { p in
            p.move(to: CGPoint(x: 900, y: 365))
            p.addLine(to: CGPoint(x: 768, y: 504))
            p.addLine(to: CGPoint(x: 791, y: 525))
            p.addLine(to: CGPoint(x: 924, y: 388))
            p.addLine(to: CGPoint(x: 899, y: 366))
            p.closeSubpath()
        }),
        // Friendship Heights
        MapRegion(id: "A08", path: Path { p in
            p.addRect(CGRect(x: 554, y: 458, width: 225, height: 38))
        }),
        // Bethesda
        MapRegion(id: "A09", path: Path { p in
            p.addRect(CGRect(x: 599, y: 415, width: 149, height: 32))
        }),
        // Medical Center
        MapRegion(id: "A10", path: Path { p in
            p.addRect(CGRect(x: 494, y: 366, width: 213, height: 37))
        }),
        // Grosvenor-Strathmore
        MapRegion(id: "A11", path: Path { p in
            p.addRect(CGRect(x: 363, y: 323, width: 317, height: 30))
        }),
        // North Bethesda
        MapRegion(id: "A12", path: Path { p in
            p.addRect(CGRect(x: 419, y: 273, width: 195, height: 39))
        }),
        // Twinbrook
        MapRegion(id: "A13", path: Path { p in
            p.addRect(CGRect(x: 374, y: 227, width: 200, height: 35))
        }),
        // Rockville
        MapRegion(id: "A14", path: Path { p in
            p.addRect(CGRect(x: 288, y: 181, width: 254, height: 33))
        }),
        // Shady Grove
        MapRegion(id: "A15", path: Path { p in
            p.addRect(CGRect(x: 264, y: 126, width: 201, height: 46))
        }),
    ]
}
