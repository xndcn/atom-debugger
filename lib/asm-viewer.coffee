{TextEditor} = require 'atom'

module.exports =
class AsmViewer extends TextEditor
  lines: null
  constructor: (params) ->
    line = params.startline
    file = params.fullname

    super params

    @GDB = params.gdb

    @lines = {}
    @setText("#{line+1}:")
    @GDB.disassembleData {file: {name: file, linenum: line+1, lines: -1}, mode: 1}, (instructions) =>
      maxOffset = -1
      for src in instructions
        for asm in src.line_asm_insn
          maxOffset = Number(asm.offset) if Number(asm.offset) > maxOffset
      maxOffsetLength = maxOffset.toString().length

      text = []
      linenum = 0
      for src in instructions
        text.push("#{src.line}:")
        @lines[Number(src.line)-1] = linenum
        linenum += 1
        for asm in src.line_asm_insn
          asm.offset = '0' unless asm.offset
          alignSpace = '                '.slice(0, maxOffsetLength-asm.offset.length)
          text.push("    #{asm['func-name']}+#{alignSpace}#{asm.offset}:    #{asm.inst}")
          linenum += 1

      @setText(text.join('\n'))
      console.log(@lines)

  fileLineToBufferLine: (line) ->
    return Number(0) unless line of @lines
    return @lines[line]

  bufferLineToFileLine: (line) ->
    lines = Object.keys(@lines)
    left = 0
    right = lines.length-1
    while left <= right
      mid = (left+right) // 2
      midLine = @lines[lines[mid]]
      if line < midLine
        right = mid - 1
      else
        left = mid + 1
    return Number(lines[left-1])

  shouldPromptToSave: ({windowCloseRequested}={}) ->
    return false
