const canvas = document.querySelector("canvas");
const ctx = canvas.getContext("2d");

let t = 0;
const imgData = ctx.createImageData(800, 600);
console.log(imgData.data.buffer); // (800*600)*4(pixel)


function plasma(t) {
    for (let i = 0; i < imgData.data.length; i+=4) {
	const src = i / 4;
	const x = src % 800;
	const y = Math.floor(src / 800);
	
	const w1 = Math.floor(((Math.sin(x*0.02+t) + 1) / 2) * 255);
	const w2 = Math.floor(((Math.sin(y*0.14+t) + 1) / 2) * 255);
	const w = (w1+w2) / 2;
	imgData.data[i + 0] = 0;
	imgData.data[i + 1] = w;   
	imgData.data[i + 2] = 0;   
	imgData.data[i + 3] = 255;
    }

ctx.putImageData(imgData, 0, 0);
}


function l() {
    plasma(t);
    t += 0.02;   
    requestAnimationFrame(l);
}

requestAnimationFrame(l);
    
