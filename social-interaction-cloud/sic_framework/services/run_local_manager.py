from sic_framework.core.component_manager_python2 import SICComponentManager
from sic_framework.services.eis.eiscomponent import EISComponent

from sic_framework.devices.common_desktop.desktop_microphone import DesktopMicrophoneSensor
from sic_framework.devices.common_desktop.desktop_text_to_speech import DesktopTextToSpeechActuator
from sic_framework.devices.common_desktop.desktop_camera import DesktopCameraSensor
from sic_framework.devices.common_desktop.desktop_speakers import DesktopSpeakersActuator

from sic_framework.services.dialogflow.dialogflow import DialogflowComponent

# If you have this service in your repo, include it (EIS is trying to start it)
from sic_framework.services.webserver.webserver_pca import WebserverComponent

if __name__ == "__main__":
    components = [
        DesktopMicrophoneSensor,
        DesktopCameraSensor,
        DesktopSpeakersActuator,
        DesktopTextToSpeechActuator,
        DialogflowComponent,
    ]
    SICComponentManager(components)