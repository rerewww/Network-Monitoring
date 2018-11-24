package Network.model;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * Created by son on 2018-11-20.
 */
@AllArgsConstructor
@Data
public class AjaxModel {
    private Boolean success;
    private String message;
    private Object data;
    private int size;
    private String exception;

    public AjaxModel(Boolean success, String message, Object data, String exception) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.exception = exception;
    }

    public AjaxModel(Boolean success) {
        this(success, "login", null, "");
    }

    public AjaxModel(Boolean success, String message, Object data) {
        this(success, message, data, "");
    }
}
