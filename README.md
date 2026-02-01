# mototrbo_tts
Generate voice announcement files from a config file of needed phrases for your MotoTRBO radio.

This project will use VS Code Dev Containers and [Piper TTS](https://github.com/OHF-Voice/piper1-gpl) to generate your voice announcement files for CPS in bulk.

## Prerequisites

This project requires VS Code with the Dev Containers plugin and internet access.
All tooling needed to build your voice files will be contained in the Dev Container Docker image.

## Usage

1. Download or clone [this repo](https://github.com/clifjones/mototrbo_tts.git) and open the folder with VS Code.
    * VS Code should prompt you to open the project in a Dev Container.
    * Answer YES and allow the container to build successfully
    ![Dev Container build](/images/dev_container_build.png)
2. Edit the [config.env](/config.env) to select your voice model.
    * You can find a complete list at [Hugging Face](https://huggingface.co/rhasspy/piper-voices)
    * You can listen to samples at [TTS Tool](https://piper.ttstool.com/)
    ![Voice model selection](/images/voice-config.png)
3. Edit the [phrases.lst](/phrases.lst) file build your filename and phrase pairs. 
    * Each line sould have a filename with no extension followed by '=' then your desired phrase.
    ![Phrase configuration](/images/announcement-file-config.png)
4. Open a new terminal from the VS Code menu and run the `./gen-files.sh` command.
    * This will download the necessary voice model files and generate the WAV files suitable to be used in CPS.
    ![gen-files.sh](/images/gen-files.png)
5. Locate your WAV files in the `./output` directory and move them to the CPS `voiceannouncement` directory normally located at `C:\Program Files (x86)\Motorola\MOTOTRBO CPS\voiceannouncement`
    * Voice announcement file source location
    ![source WAV files](/images/output_dir.png)
    * Voice announcement file target location
    ![WAV file target directory](/images/voice_announcements_directory.png)
    * You may need to re-start CPS if you have it open while adding these files.
6. Load a radio with the generated announcement files.
    * Connect the target radio to CPS.
    * Open the `Manage Voice Announcement` window from the CPS menus.
    * Select the desired announcement files to use and send them to the radio.
    ![Manage announcement files](/images/manage_voice_announcement.png)
7. Use the voice announcement files
    * Read the codeplug from the radio into CPS after the announcement files transfer so CPS will know that they can be selected.
    * Ensure that you have the announcement type set to `Voice Announcement Files`.
    ![Announcement settings](/images/announcement_settings.png)
    * Select your files where you would like them announced.
    ![Zone announcement](/images/zone_voice_ann.png)
    ![Channel announcement](/images/channel_voice_ann.png)

    