package Service;

import Network.PacketContainer;
import Pcap.JnetPcacp;
import Pcap.JnetPcapFactory;
import lombok.extern.slf4j.Slf4j;
import org.jnetpcap.PcapIf;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;

/**
 * Created by son on 2018-10-28.
 */
@Slf4j
@Service
public class NetworkService {
    private JnetPcapFactory jnetPcapFactory;
    private Map<String, Boolean> deviceList = new HashMap<>();

    @Autowired
    public NetworkService(final JnetPcapFactory jnetPcapFactory) {
        this.jnetPcapFactory = jnetPcapFactory;

        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        List<PcapIf> pcapIfs = jnetPcacp.getNetworkDevices();

        for (PcapIf pcapIf : pcapIfs) {
            deviceList.put(pcapIf.getName(), false);
        }
    }

    public PacketContainer analyze() throws IOException {
        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        return jnetPcacp.analyze(new PacketContainer());
    }

    public JSONArray getNetworkDevices() {
        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        List<PcapIf> devices = jnetPcacp.getNetworkDevices();

        JSONArray jsonArray = new JSONArray();
        for (PcapIf device : devices) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name", device.getDescription());
            jsonObject.put("id", device.getName());
            jsonArray.put(jsonObject);
        }
        return jsonArray;
    }

    public boolean activityDevice(final String id) {
        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        if (!jnetPcacp.activityDevice(id)) {
            return false;
        }
        deviceList.put(id, true);
        return true;
    }

    public String getActiveDevice() {
        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        String id = "";
        for (Map.Entry<String, Boolean> device : deviceList.entrySet()) {
            if (!device.getValue()) {
                continue;
            }
            for (PcapIf pcapIf : jnetPcacp.getNetworkDevices()) {
                if (!pcapIf.getName().equals(device.getKey())) {
                    continue;
                }
                id = pcapIf.getDescription();
            }
        }
        return id;
    }

    public boolean isEmptyDevice() {
        JnetPcacp jnetPcacp = jnetPcapFactory.getPcap();
        return jnetPcacp.emptyDevice();
    }

    public boolean checkDevice() {
        for (Map.Entry<String, Boolean> device : deviceList.entrySet()) {
            if (device.getValue()) {
                log.info("device: " + device.getKey() + " status: " + device.getValue());
                return true;
            }
        }
        return false;
    }
}
