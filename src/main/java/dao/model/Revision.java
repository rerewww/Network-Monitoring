package dao.model;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * Created by son on 2018-12-02.
 */
@Data
@AllArgsConstructor
public class Revision {
    public String localAddress;
    public String remoteAddress;
    public String protocol;
    public String info;
}
