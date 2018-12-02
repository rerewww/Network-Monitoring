package dao;

import dao.model.Revision;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;

import javax.sql.DataSource;
import java.sql.*;
import java.util.List;
import java.util.Map;

/**
 * Created by son on 2018-12-02.
 */
public class RevisionDao {
    private JdbcTemplate jdbcTemplate;

    @Autowired
    public RevisionDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public void insert(final List<Map<String, String>> items) {
        for (Map<String, String> item : items) {
            jdbcTemplate.update(new PreparedStatementCreator() {
                @Override
                public PreparedStatement createPreparedStatement(Connection con)
                        throws SQLException {
                    PreparedStatement pstmt = con.prepareStatement(
                            "insert into revision (local_address, remote_address, protocol, info) "+
                                    "values (?, ?, ?, ?)");
                    pstmt.setString(1,  item.get("localAddress"));
                    pstmt.setString(2,  item.get("remoteAddress"));
                    pstmt.setString(3,  item.get("protocol"));
                    pstmt.setString(4,  item.get("info"));
                    return pstmt;
                }
            });
        }
    }

    public List<Revision> select() {
        List<Revision> results = jdbcTemplate.query("select * from revision", new RowMapper<Revision>() {
            @Override
            public Revision mapRow(ResultSet resultSet, int rowNum)
                    throws SQLException {
                Revision revision = new Revision(resultSet.getString("local_address"),
                        resultSet.getString("remote_address"),
                        resultSet.getString("protocol"),
                        resultSet.getString("info"));
                return revision;
            }
        });
        return results;
    }
}
