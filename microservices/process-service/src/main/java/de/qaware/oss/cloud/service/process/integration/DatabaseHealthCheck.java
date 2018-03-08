package de.qaware.oss.cloud.service.process.integration;

import com.codahale.metrics.health.HealthCheck;
import de.qaware.oss.metrics.jsr340.DataSourceHealthChecker;
import de.qaware.oss.metrics.jsr340.NamedHealthCheck;

import javax.annotation.Resource;
import javax.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;

/**
 * Health check for the database
 * </p>
 * Try to get a connection to the database to make sure it is still available
 */
@ApplicationScoped
public class DatabaseHealthCheck extends NamedHealthCheck {

    private final DataSourceHealthChecker healthChecker;

    @Resource(lookup = "jdbc/ProcessDb")
    private DataSource dataSource;

    protected DatabaseHealthCheck() {
        super("Database");
        healthChecker = new DataSourceHealthChecker();
    }

    @Override
    protected HealthCheck.Result check() {
        return healthChecker.check(dataSource);
    }
}
