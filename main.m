function main()
%MAIN Runs the show.

import LabName.*;
import NamingMethod.*;
import Recording.*;
import GUI.*;
import EntryScreen.*;
import LabScreen.*;
import RatScreen.*;
import RecordScreen.*;
%L = import;

% The same GUI objects are used until the program is closed so that the
% user doesn't have to constantly redo the procedure from opening the
% program.
entryScr = EntryScreen();
labScr = LabScreen();
ratScr = RatScreen();
recordScr = RecordScreen();



end

