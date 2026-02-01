#!/usr/bin/env bash
set -e

. ./config.env
. .venv/bin/activate

# Cleanup function to remove temporary files
cleanup() {
    local exit_code=$?
    if [ -n "$temp_wav" ] && [ -f "$temp_wav" ]; then
        echo "Cleaning up temporary file: $temp_wav"
        rm -f "$temp_wav"
    fi
    # Remove any other temp files that might exist
    if [ -d "$TMP_DIR" ]; then
        rm -f "$TMP_DIR"/*_temp.wav 2>/dev/null || true
    fi
    if [ $exit_code -ne 0 ]; then
        echo "Script exited with error code: $exit_code"
    fi
    exit $exit_code
}

# Set trap to cleanup on EXIT, ERR, INT, and TERM
trap cleanup EXIT INT TERM ERR

python3 -m piper.download_voices --data-dir $DATA_DIR $VOICE

# Create TMP_DIR if it doesn't exist
mkdir -p "$TMP_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$OUTPUT_DIR"

# Clean the output directory before processing
echo "Cleaning output directory: $OUTPUT_DIR"
rm -f "$OUTPUT_DIR"/*.wav 2>/dev/null || true

# Process each line in phrases.lst
# Use file descriptor 3 to avoid stdin conflicts with piper/ffmpeg
while read -r line <&3 || [ -n "$line" ]; do
    # Skip blank lines
    [[ -z "$line" ]] && continue
    
    # Skip comment lines (starting with #)
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    
    # Split line on first '=' character
    filename="${line%%=*}"
    phrase="${line#*=}"
    
    # Skip if no '=' found (invalid format)
    [[ "$filename" == "$phrase" ]] && continue
    
    # Trim whitespace from filename
    filename=$(echo "$filename" | xargs)
    
    # Generate initial WAV file in temp directory
    temp_wav="$TMP_DIR/${filename}_temp.wav"
    output_wav="$OUTPUT_DIR/${filename}.wav"
    
    echo "Processing: $filename = $phrase"
    
    # Execute piper command with the phrase
    echo "$phrase" | python3 -m piper --model "$DATA_DIR/$VOICE.onnx" --output_file "$temp_wav"
    
    # Convert to MotoTRBO specifications using ffmpeg:
    # - ulaw encoding
    # - 8kHz sample rate
    # - 16-bit resolution
    # - Normalize audio to -16dB with peaks no more than -4dB
    ffmpeg -y -loglevel error -i "$temp_wav" \
        -acodec pcm_mulaw \
        -ar 8000 \
        -sample_fmt s16 \
        -af "loudnorm=I=-16:TP=-4:LRA=11" \
        "$output_wav"
    
    # Check file size (max 320kB)
    file_size=$(stat -c%s "$output_wav" 2>/dev/null || stat -f%z "$output_wav" 2>/dev/null)
    if [ "$file_size" -gt 327680 ]; then
        echo "WARNING: $output_wav exceeds 320kB (${file_size} bytes)"
    fi
    
    # Clean up temp file
    rm -f "$temp_wav"
    
    echo "Created: $output_wav"
done 3< phrases.lst

echo "All files processed successfully!"
