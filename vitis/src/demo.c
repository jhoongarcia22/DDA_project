/************************************************************************/
/*																		*/
/*	demo.c	--	Zybo DMA Demo				 						*/
/*																		*/
/************************************************************************/
/*	Author: Sam Lowe											*/
/*	Copyright 2015, Digilent Inc.										*/
/************************************************************************/
/*  Module Description: 												*/
/*																		*/
/*		This file contains code for running a demonstration of the		*/
/*		DMA audio inputs and outputs on the Zybo.					*/
/*																		*/
/*																		*/
/************************************************************************/
/*  Notes:																*/
/*																		*/
/*		- The DMA max burst size needs to be set to 16 or less			*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/* 																		*/
/*		9/6/2016(SamL): Created										*/
/*      5/9/2023(alexparrado): Realtime
 /*																		*/
/************************************************************************/

#include "demo.h"

#include "audio/audio.h"
#include "dma/dma.h"
#include "intc/intc.h"
#include "userio/userio.h"
#include "iic/iic.h"

/***************************** Include Files *********************************/

#include "xaxidma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xdebug.h"
#include "xiic.h"
#include "xaxidma.h"
#include "xtime_l.h"

#include <math.h>

#ifdef XPAR_INTC_0_DEVICE_ID
#include "xintc.h"
#include "microblaze_sleep.h"
#else
#include "xscugic.h"
#include "sleep.h"
#include "xil_cache.h"
#endif

/************************** Constant Definitions *****************************/

// ADC/DAC sampling rate in Hz
#define AUDIO_SAMPLING_RATE	  96000

// Number of samples for record/playback buffers
#define NR_AUDIO_SAMPLES	(2048)

/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER	10000

#define TEST_START_VALUE	0x0

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/
#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif

/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */

static XIic sIic;
static XAxiDma sAxiDma; /* Instance of the XAxiDma */

static XGpio sUserIO;

#ifdef XPAR_INTC_0_DEVICE_ID
static XIntc sIntc;
#else
static XScuGic sIntc;
#endif

volatile sDemo_t Demo;

//
// Interrupt vector table
#ifdef XPAR_INTC_0_DEVICE_ID
const ivt_t ivt[] = {
	//IIC
	{	XPAR_AXI_INTC_0_AXI_IIC_0_IIC2INTC_IRPT_INTR, (XInterruptHandler)XIic_InterruptHandler, &sIic},
	//DMA Stream to MemoryMap Interrupt handler
	{	XPAR_AXI_INTC_0_AXI_DMA_0_S2MM_INTROUT_INTR, (XInterruptHandler)fnS2MMInterruptHandler, &sAxiDma},
	//DMA MemoryMap to Stream Interrupt handler
	{	XPAR_AXI_INTC_0_AXI_DMA_0_MM2S_INTROUT_INTR, (XInterruptHandler)fnMM2SInterruptHandler, &sAxiDma},
	//User I/O (buttons, switches, LEDs)
	{	XPAR_AXI_INTC_0_AXI_GPIO_0_IP2INTC_IRPT_INTR, (XInterruptHandler)fnUserIOIsr, &sUserIO}
};
#else
const ivt_t ivt[] = {
//IIC
		{ XPAR_FABRIC_AXI_IIC_0_IIC2INTC_IRPT_INTR,
				(Xil_ExceptionHandler) XIic_InterruptHandler, &sIic },
		//DMA Stream to MemoryMap Interrupt handler
		{ XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR,
				(Xil_ExceptionHandler) fnS2MMInterruptHandler, &sAxiDma },
		//DMA MemoryMap to Stream Interrupt handler
		{ XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR,
				(Xil_ExceptionHandler) fnMM2SInterruptHandler, &sAxiDma },
		//User I/O (buttons, switches, LEDs)
		{ XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR,
				(Xil_ExceptionHandler) fnUserIOIsr, &sUserIO } };
#endif

// Function to perform sign extension
s32 sign_extend_24_32(u32 x) {
	const int bits = 24;
	uint32_t m = 1u << (bits - 1);
	return (x ^ m) - m;
}

/*****************************************************************************/
/**
 *
 * Main function
 *
 * This function is the main entry of the interrupt test. It does the following:
 *	Initialize the interrupt controller
 *	Initialize the IIC controller
 *	Initialize the User I/O driver
 *	Initialize the DMA engine
 *	Initialize the Audio I2S controller
 *	Enable the interrupts
 *	Wait for a button event then start selected task
 *	Wait for task to complete
 *
 * @param	None
 *
 * @return
 *		- XST_SUCCESS if example finishes successfully
 *		- XST_FAILURE if example fails.
 *
 * @note		None.
 *
 ******************************************************************************/
int main(void) {
	int Status;

	// Pointer to circular buffer
	volatile u32 *circular_buffer = (u32*) XPAR_MY_CIRCULAR_BUFFER_0_S00_AXI_BASEADDR;

	// for-loop counter
	u32 i;

	// Memory addresses for audio data (double buffering)
	volatile u32 *input_buffer1 = MEM_BASE_ADDR;
	volatile u32 *input_buffer2 = MEM_BASE_ADDR + (1 << 21);
	volatile u32 *output_buffer = MEM_BASE_ADDR + (1 << 22);

	// Pointers for double buffering
	volatile u32 *capturing_audio = input_buffer1;
	volatile u32 *processing_audio = input_buffer2;
	volatile u32 *aux_ptr;

	Demo.u8Verbose = 0;

	xil_printf("\r\n--- Entering main() --- \r\n");

	//
	//Initialize the interrupt controller

	Status = fnInitInterruptController(&sIntc);
	if (Status != XST_SUCCESS) {
		xil_printf("Error initializing interrupts");
		return XST_FAILURE;
	}

	// Initialize IIC controller
	Status = fnInitIic(&sIic);
	if (Status != XST_SUCCESS) {
		xil_printf("Error initializing I2C controller");
		return XST_FAILURE;
	}

	// Initialize User I/O driver
	Status = fnInitUserIO(&sUserIO);
	if (Status != XST_SUCCESS) {
		xil_printf("User I/O ERROR");
		return XST_FAILURE;
	}

	//Initialize DMA
	Status = fnConfigDma(&sAxiDma);
	if (Status != XST_SUCCESS) {
		xil_printf("DMA configuration ERROR");
		return XST_FAILURE;
	}

	//Initialize Audio I2S
	Status = fnInitAudio();
	if (Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	{
		XTime tStart, tEnd;

		XTime_GetTime(&tStart);
		do {
			XTime_GetTime(&tEnd);
		} while ((tEnd - tStart) / (COUNTS_PER_SECOND / 10) < 20);
	}
	//Initialize Audio I2S
	Status = fnInitAudio();
	if (Status != XST_SUCCESS) {
		xil_printf("Audio initializing ERROR");
		return XST_FAILURE;
	}

	// Enable all interrupts in our interrupt vector table
	// Make sure all driver instances using interrupts are initialized first
	fnEnableInterrupts(&sIntc, &ivt[0], sizeof(ivt) / sizeof(ivt[0]));

	xil_printf(
			"----------------------------------------------------------\r\n");
	xil_printf("Zybo DMA Real Time Audio Demo\r\n");
	xil_printf(
			"----------------------------------------------------------\r\n");

	// Clear DMA flags
	Demo.fDmaS2MMEvent = 0;
	Demo.fDmaMM2SEvent = 0;

	// Input signal from microphone
	fnSetMicInput();

	// Enable recording and playback
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, 0x00000003);

	// Number of samples of audio transfers (stream)
	Xil_Out32(I2S_PERIOD_COUNT_REG, NR_AUDIO_SAMPLES);

	// Start first DMA transactions
	fnAudioRecord2(sAxiDma, capturing_audio, NR_AUDIO_SAMPLES);
	fnAudioPlay2(sAxiDma, output_buffer, NR_AUDIO_SAMPLES);

	// Circular buffer setting up
	circular_buffer[1] = 9600;

	// For AM modulator
	double phase = 0.0;
	double f_Hz = 500;
	double Om = 2 * M_PI * f_Hz / (double) AUDIO_SAMPLING_RATE;

	// Main loop
	while (1) {

		// Enable playback and recording streams
		Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000003);

		// Wait for audio recording to finish
		while (Demo.fDmaS2MMEvent == 0)
			;

		// Clear recording flag
		Demo.fDmaS2MMEvent = 0;

		// Disable recording stream temporarily
		Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000001);

		// Pointers exchange for double buffering
		aux_ptr = processing_audio;
		processing_audio = capturing_audio;
		capturing_audio = aux_ptr;

		// Start recording of signal
		fnAudioRecord2(sAxiDma, capturing_audio, NR_AUDIO_SAMPLES);

		// Enable playback and recording streams
		Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000003);

		// Invalidate cache to access main memory
		Xil_DCacheInvalidateRange((u32) processing_audio,
				sizeof(u32) * NR_AUDIO_SAMPLES);

		// Signal processing loop (your code goes here!!)
		for (i = 0; i < NR_AUDIO_SAMPLES; i++) {
			circular_buffer[0] = processing_audio[i];
			output_buffer[i]=processing_audio[i];//+circular_buffer[0];

			//output_buffer[i] = ((s64) sign_extend_24_32(processing_audio[i])
			//		* (s64) ((1<<23) * cos(phase))) >> 23;

			//phase = fmod(phase + Om, 2 * M_PI);
		}

		// Flush cache data to main memory
		Xil_DCacheFlushRange((u32) output_buffer,
				sizeof(u32) * NR_AUDIO_SAMPLES);

		// Wait for previous playback to complete
		while (Demo.fDmaMM2SEvent == 0)
			;

		// Stop playback stream temporarily
		Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000002);
		Demo.fDmaMM2SEvent = 0;

		// Start playback of processed signal
		fnAudioPlay2(sAxiDma, output_buffer, NR_AUDIO_SAMPLES);

		// Checking the DMA Error event flag
		if (Demo.fDmaError) {
			xil_printf("\r\nDma Error...");
			xil_printf("\r\nDma Reset...");

			Demo.fDmaError = 0;
			Demo.fAudioPlayback = 0;
			Demo.fAudioRecord = 0;
		}

		// Checking the btn change event
		if (Demo.fUserIOEvent) {
			xil_printf("\r\nButton: %c", Demo.chBtn);
			switch (Demo.chBtn) {
			case 'u':

				break;
			case 'd':

				break;
			case 'r':

				break;
			case 'l':

				break;
			default:
				break;
			}

			// Reset the user I/O flag
			Demo.chBtn = 0;
			Demo.fUserIOEvent = 0;

		}

	}

	xil_printf("\r\n--- Exiting main() --- \r\n");

	return XST_SUCCESS;

}

