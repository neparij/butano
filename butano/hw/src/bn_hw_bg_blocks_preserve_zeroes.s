    .section .iwram, "ax", %progbits
    .align 2
    .arm
    .global bn_hw_bg_blocks_commit_half_words_preserve_zeroes
    .type bn_hw_bg_blocks_commit_half_words_preserve_zeroes, STT_FUNC
bn_hw_bg_blocks_commit_half_words_preserve_zeroes:

.half_words_loop_preserve_zeroes:
    ldrh    r12, [r0], #2

    @ Extract lower byte -> r4
    mov     r4, r12
    bic     r4, r4, #0xFF00            @ clear upper byte

    @ Extract upper byte -> r5
    mov     r5, r12, LSR #8            @ shift right to get upper byte
    bic     r5, r5, #0xFF00            @ ensure only lower 8 bits

    @ If lower byte != 0, add offset
    cmp     r4, #0
    addne   r4, r4, r2

    @ If upper byte != 0, add offset
    cmp     r5, #0
    addne   r5, r5, r2

    @ Combine back into a 16-bit value
    orr     r12, r4, r5, LSL #8

    strh    r12, [r3], #2
    subs    r1, #1
    bne     .half_words_loop_preserve_zeroes

    bx      lr
