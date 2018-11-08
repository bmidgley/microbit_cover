//!OpenSCAD
// 2018-10-08 modified the "microbit diffuser" below to make the pixels more distinct -Brad

// The Microbit is a cool new thing from the BBC.
// It runs micropython.

// I wrote a flame simulator on it and this panel fits on top
// So you can adjust the parameters with the buttons and// see a diffuse fire display through the plastic shell



board_w = 52;    // Width of the Microbit
board_h = 35;    // Height of the Microbit
board_d = 1.7;   // Thickness of the circuit board
standoff = 2;    // How far off does the fire_place stand from the board
thickness = 2.5; // Thickness of the 3D print in general.
//
fire_pane_w = 22;    // Height of the display LEDs
fire_pane_h = 22;    // Width of the display LEDs
fire_pane_off = 10;  // Distance from base to bottom of display recess
fire_pane_d = 1;   // Thin section over the LEDs to diffuse them.
fire_cell_w = 3.2; // width of each cell w = 5*w + 4*s
fire_cell_off = 1; // distance between cells
//
button_off_w = 4;   // Offset of buttons from side
button_off_h = 17;  // Offset of buttons from base of Microbit
button_w = 8;       // Width of buttons
//
usb_w = 45;     // width of recess for the USB plug (15)


Delta = 0.1; // used to make sure things overlap properly for a nice 3D model

//--------------------------------------------------------------------------
// The base plate or panel
module plate() {
	translate([0,board_h/2,thickness/2])
		cube(size=[board_w,board_h, thickness], center=true);
}

// hole for a button (mirrored for other side)
module button() {
	translate([(board_w-button_off_w-button_w)/2, button_off_h+button_w/2,0])
		cube(size=[button_w,button_w,button_w], center=true);
}

// Recess for USB plug
module usb() {
	h = board_d+standoff+thickness+Delta*2;
	translate([0,-thickness/2,-thickness-Delta])
		cube([usb_w,thickness*2,h*2],center=true);
}

// Little standoffs to seat board height properly
module standoff() {
	translate([(board_w-button_off_w-button_w)/2, board_h-button_off_h, Delta-standoff/2])
		cube([standoff,standoff,standoff], center=true);
	translate([(board_w-button_off_w-button_w)/2, thickness, Delta-standoff/2])
		cube([standoff,standoff,standoff], center=true);
}

// Sides and bottom lip
module sides() {
	h = board_d+standoff+thickness;
	// bottom
	translate([0,-thickness/2+Delta, thickness-h/2])
		cube([board_w, thickness, h ], center=true);
	// side 1
	translate([-(thickness+board_w)/2+Delta,(board_h-thickness)/2+Delta, thickness-h/2])
		cube([thickness, board_h+thickness, h ], center=true);
	// side 2
	translate([(thickness+board_w)/2-Delta,(board_h-thickness)/2+Delta, thickness-h/2])
		cube([thickness, board_h+thickness, h ], center=true);
}

module button_row() {
		translate([0,fire_pane_h,thickness/2-fire_pane_d])
			cube([fire_cell_w,fire_cell_w,2*thickness], center=true);
		translate([fire_cell_w + fire_cell_off,fire_pane_h,thickness/2-fire_pane_d])
			cube([fire_cell_w,fire_cell_w,2*thickness], center=true);
		translate([2*fire_cell_w + 2*fire_cell_off,fire_pane_h,thickness/2-fire_pane_d])
			cube([fire_cell_w,fire_cell_w,2*thickness], center=true);
		translate([-fire_cell_w - fire_cell_off,fire_pane_h,thickness/2-fire_pane_d])
			cube([fire_cell_w,fire_cell_w,2*thickness], center=true);
		translate([-2 * fire_cell_w - 2* fire_cell_off,fire_pane_h,thickness/2-fire_pane_d])
			cube([fire_cell_w,fire_cell_w,2*thickness], center=true);
    
}
//The entire object made of parts
module fire_place() {
	difference() {
		// baseplate and sides
		union() {
			plate();
			sides();
		}
		// subtracting USB, buttons, LED region
		usb();
		button();
		mirror([1,0,0])
			button();
		// flame region
		translate([0, 0, 0]) button_row();
		translate([0, fire_cell_w + fire_cell_off, 0]) button_row();
		translate([0, 2*(fire_cell_w + fire_cell_off), 0]) button_row();
		translate([0, -1*(fire_cell_w + fire_cell_off), 0]) button_row();
		translate([0, -2*(fire_cell_w + fire_cell_off), 0]) button_row();
	}
	// Add standoffs
	//standoff();
	//mirror([1,0,0]) standoff();
	// Some measures to make sure its all working right :)
	// color([1,0,0])
		// cube([32,1,1], center=true);
	// color([1,0,0])
	// translate([board_w/2,button_off_h/2,3])
		// cube([1,button_off_h,1], center=true);
}

// Make it upside down so can be printed easily.
rotate([180,0,0])
	fire_place();